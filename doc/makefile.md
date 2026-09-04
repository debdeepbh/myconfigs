# Makefile help

## Rule to write a makefile

```
output_filename: dependency_filename_1 dependency_filename_2
	full_shell_command_here
```

* There has to be a Tab character before the `full_shell_command_here`.
* When `make` is run without any argument, the first rule is executed. So, it is convenient to add the rule `all:` that combines all the steps.
* The `output_filename` can also be replaced by a `rule_name` which is not a filename, but a random string. e.g.
```
dir:
	mkdir build obj
clean:
	rm -r build/* obj/*
```
* When `make output_filename` is executed, `make` checks if `dependency_filename_1` and `dependency_filename_2` are up to date. If they are not, the rule associated with those files are executed first, provided they exist, viz
```
dependency_filename_1:
	shell_command_that_outputs dependency_filename_1
dependency_filename_2:
	shell_command_that_outputs dependency_filename_2
```

Here is an example where we have a client file `main.cpp`, headerfile `includes/header.h` and implementation `includes/header.cpp` of the header. We would like the following:
* If header file and implementations are unchanged and only `main.cpp` is modified, compile only `main.cpp`
* If header file or the implementation is modified, compile all 3 files.
Example makefile to accomplish that:
```
main.out: header.o
	gcc main.cpp header.o -o main.out
header.o: header.cpp header.h
	gcc -c header.cpp -o header.o
```

Comment: It is probably safe to assume that if you edit the header file `header.h`, you would edit the implementation file `header.cpp` as well. Moreover, it is hard to list down all the header files which the file `header.o` depends on. So either be extremely cautious while running `make` to avoid missing out on compiling edited files, or meticulously list down all the dependency files of `header.o`.

* We can use `$@` to denote the target `output_filename` and `$?` to denote _all_ the dependencies (i.e. `dependency_filename_1 dependency_filename_2`). Another macro is using `%.` to denote _any_. e.g. the code
```
file1.o: file1.cpp file1.h
	gcc -c file1.cpp -o file1.o
file2.o: file2.cpp file2.h
	gcc -c file2.cpp -o file2.o
file3.o: file3.cpp file3.h
	gcc -c file3.cpp -o file3.o
```
can be replaced by

```
%.o: %.cpp %.h
	gcc -c $? -o $@
```
**Caution:** Compiling the cpp file along with the header file into an object file (`gcc -c file.cpp file.h`) and linking it to other files causes a syntax error `.o: file format not recognized; treating as linker script`. (Why?)
Two alternatives:
 1. Use `$<` (instead of `$?`) to denote the _first_ argument in the dependency list.
 2. Remove the `%.h` from the dependency list

* To forcefully mark all the files as up-to-date, run `make -t`. This is useful when you do not want to recompile the header and implementation _even after_ you have edited them, but you only want to compile the client runfile.

* Specify the location of the header files using `-I` flags, e.g.
```
INCLUDES_DIR_1 = includes
INCLUDES_DIR_2 = headers

CPPFLAGS += -I$(INCLUDES_DIR_1)
CPPFLAGS += -I$(INCLUDES_DIR_2)
```
later, supply that to the `g++` parameters in the makefile using `g++ -c input.cpp $(CPPFLAGS)`

* C++ `undefined reference to` error after the definition of the function is clearly defined:
Linking issue: Make sure the object (`.o`) file created from the implementation of the file is linked to the client file, something like
```
gcc main.cpp obj1.o obj2.o -o outfile
```

### String replacement

```
# Get all cpp files in the subdir structure
T_cpp = $(wildcard  $(INCLUDE_DIR)/**/*.cpp)
# .cpp replaced by .o
T_o = $(T_cpp:%.cpp=%.o)
# Replace the include path structure by object path structure: pattern-substitute
T_o_Build = $(patsubst $(INCLUDE_DIR)/%, $(OBJ_DIR)/%, $(T_o))
```

* Generating the object files in a separate directory (from the source code) while maintaining the directory structure: 
If your `.h` and `.cpp` files reside in `$(INCLUDE_DIR)` directory (within subdirectories of if, possibly) and you want move the object files to `$(OBJ_DIR)`, do
```
$(OBJ_DIR)/%.o: $(INCLUDE_DIR)/%.cpp
	@echo "Building:"
	$(CC) $(CCFLAGS) -c $? -o $@ $(CPPFLAGS)
```

This assumes that _all_ the subdirectories of `$(INCLUDE_DIR)` are to be compiled.

Later, supply all the object files to the main target using a wildcard like `ALL_O = $(wildcard  $(OBJ_DIR)/**/*.o)`
```
ALL_O = $(wildcard  $(OBJ_DIR)/**/*.o)
mainTarget: ALL_O
	$(CC) $(CCFLAGS) main/mainTarget.cpp $? -o $@ $(CPPFLAGS)
```

### Timestamp in C++
* To print the current time in C++ do the following:
```
#include <time.h>

time_t my_time;
char timestring[80];
strftime(timestring, 80, "%F-%T", localtime(&my_time));

std::cout << timestring << std::endl;
```


