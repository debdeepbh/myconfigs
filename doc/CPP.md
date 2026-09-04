# C++ tutorial comparison with C
[See](http://www.ericbrasseur.org/cppcen.html?i=1)

## Strings

Define strings as `std::string` datatype with `#include<string>` (or just `string` if `using namespace std;` is present). No need to do `strcpy()`, we can equate strings.
```
#include <string>
using namespace std;
int main(){
	string astring = "hello";
	// copy to another string
	string another_string;
	another_string = astring;
	cout << another_string << endl;
	return 0;
}
```

	

## Changing value by reference
The new datatype `double &` (caution: not `double *`) is introduced. `double &()` has datatype `double` and `&()` is implicitly applied and converted back based on the context.

In C, to set `r=100` via reference, we can do
```
void main(){
	double hundred = 100;
	double *mem = &hundred; // mem is of datatype double *, &hundred is the reference
	double r = *mem;	//the value of reference mem	

	cout << r << endl;
}
```

In C++,  `double &`, can create a symbolic link.
```
void main(){
	double hundred = 100;
	double &r = hundred; // r is double, &(r) is set to &(hundred)

	// changing the value of symlink changes the value of the target
	r = 200;
	cout << hundred << endl;	// outputs 200 instead of 100
}
}
```
This is equivalent to considering `r` as a symbolic link to `hundred`. The symlink to `r` cannot be changed at a later state.

## Passing by reference

Changing the value of a variable via a function is done in C like this:
```
void main(){
	double r = 50;
	s = change(&r); // &r is the address of r
}
void change(double * v){ 	// double * is the datatype (address type) of the input
	*v = 100;		// *v = *(&r) = r
}
```
In C++, it can be done using symlink `double &`:
```
void main(){
	double r = 50;
	s = change(r); // &r is the address of r
}
void change(double &v){ 	// v is a symlink of r via reference	
	v = 100;		
}
```

		
## Default values

This allows the number of inputs to be variable as well.

```
double test (double a, double b = 7) {
   return a - b;
}

void main () {
   cout << test (14, 5) << endl;    // Displays 14 - 5
   cout << test (14) << endl;       // Displays 14 - 7
}
```


## See the datatype of a variable
See the datatype of the variable `r` using
```
#include<typeinfo>
cout << typeid(r).name() << endl;
```


## C++ class 

Recall, a C `struct` can be defined by
```
using namespace std;
#include <iostream>

struct vector {
   double x;
   double y;

   double area () {
      double s;
      s = x * y;
      if (s < 0) s = -s;
      return s;
   }
};

int main () {
   vector a;

   a.x = 3;
   a.y = 4;

   cout << "The surface of a: " << a.area() << endl;

   return 0;
}
```

A __class__ is a `struct` with _hidden_ variables that cannot be accessed from outside. To allow access to specific members, use `public:`. i.e.
```
class vector {
public:
   double x;
   double y;

   double area () {
      double s;
      s = x * y;
      if (s < 0) s = -s;
      return s;
   }
}
```
Everything else remains the same.


#### Constructor

We define a class called `vector`. The constructor `vector(a,b)` is defined within the class.


```
class vector {
public:

   double x;
   double y;

   vector (double a = 0, double b = 0) {
      x = a;
      y = b;
   }
};

int main () {

	// define a instance k of class vector
   vector k;
   cout << "vector k: " << k.x << ", " << k.y << endl << endl;

   vector m (45, 2);
   cout << "vector m: " << m.x << ", " << m.y << endl << endl;

   vector p (3);
   cout << "vector p: " << p.x << ", " << p.y << endl << endl;

   return 0;
}
```

A __shorter__ way to define constructors and set default values to the public variables (initialize the public variables) is by _direct initialization_:
```
class Point3 {
public:
  double d_x;
  double d_y;
  double d_z;

  Point3() : d_x(0.), d_y(0.), d_z(0.){};
}
```

or, alternatively
```
class Point3 {
public:
  Point3(double d_x, double d_y, double d_z) : d_x(0.), d_y(0.){
      d_z = 0;
  };
}
```

Here, the constructor assigns a zero double value to the all public variables.


Better define a _destructor_ (using `~<class_name>`) to free memory if `new` has been used to allocate memory within the constructor.

[ ] Does not work
```
#include<sting>
#include<iostream>
using namespace std;

class vector {
public:

   double x;
   double y;
   double *asso_matrix;

   vector (double a = 0, double b = 0) {
      x = a;
      y = b;
      asso_matrix = new double [10];	// allocate memory
   }

   ~vector(){
	delete [] asso_matrix;
   }
};
```

* If another class B is a member variable of class A, how do I initialize B from A's constructor?
Use shortcut assignment like this:
```
class B{
public:
	int size;
	B(int N){
		size = N;
	}
};

Class A{
public:
	int length;
	B instB;

	// constructor
	A(int M): instB(M){
		length = M;
	}
```


##### Templated constructor
If your constructor depends on a template, you _cannot_ move the implementation of the constructor outside the header file, where the constructor is defined.
For example, the following code will throw error `undefined reference to`...:

In `file.h`
```
template <typename ttype>
class cl{
	public:
		int N;
		cl(ttype R);
};
```
In `file.cpp`
```
template <typename ttype>
cl<ttype>::cl(ttype R){
	// do something with R
}
```

To avoid this error, either move the implementation to the header file, **or** list down examples of possible `ttype` at the end of the implementation file using the keyword `template` (e.g. `template class<ttype_1>;` etc).
I prefer the second version since header-implementation separation is maintained (you can hide the implementation after `.o` files are generated).

 1. Implement where it is defined
In `file.h`	
```
template <typename ttype>
class cl{
	public:
		int N;
		cl(ttype R){
			// do something with R
		};
};
```
 or implement later in the same header file
In `file.h`
```
template <typename ttype>
class cl{
	public:
		int N;
		cl(ttype R);
};

template <typename ttype>
cl<ttype>::cl(ttype R){
	// do something with R
}
```
 
 2. List down examples of _all_ possible `ttype`s that you will be using through that template:
In file `file.cpp`
```
template <typename ttype>
cl<ttytype>::cl(ttype R){
	// do something with R
}

template cl<double>;
template cl<int>;
template cl<RowVector2d>;
```


Such a terrible failure by C++ people to resolve the inconsistency between separation of definition vs implementation and templating.
	
##### Templated function
Similar to templated constructors, if you want to separate the header file from its implementation, we need instantiate the templated functions. For example,
In `code.h`
```
template <typename ttype>
int myfunc(ttype a, ttype b, double c);
```
In `code.cpp`
```
template <typename ttype>
int myfunc(ttype a, ttype b, double c){
	//implementation goes here
}

template int mufunc(string a, string b, double c);
template int mufunc(Vector2d a, Vector2d b, double c);
```



##### Initialize a class via its constructor _after_ it is defined without any constructor
Not really initialization, but assignment:
```
class Particle{
	public:
	size N;
	Particle(int a){
		N = a;
	}
};

void main(){
	Particle P;
	P = Particle(10);
}
```
		

#### Accessing class variables and methods
* The variables and functions (_methods_) within `public:` can be accessed (or set) by using the dot operator.
Let the class `vector` be defined as

```
class vector {
public:
   double x;
   double y;
}
```

Now, within `int main()`, we can do

```
vector v; 
v.x = 5;
```
* The arrow operator `->` can be used to access variables and methods of a class instance if the instance name is a reference. i.e.
```
vector * v = new vector ;
v->x = 5;
delete v;
```
or
```
vector u;
u.x = 5;
u.y = 4;

vector * v;
v = &u
v->x = 10;
```

__Caution:__ Note that 
```
vector *v;
v->x = 5;
```
results in segmentation fault since `v` is never initialized and hence `v->x` points to a non-existing location in memory. In the fist example `new` allocates memory (which is a form of initialization), and in the second example `v = &u` copies the already-initialized `u` into `v`, thus providing `v` with well-defined memory location. An alternative would be to redefine the class to add a constructor `vector()` within it and make sure the variables `x` and `y` are initialized there, possible via default variables.

Similar statements hold for methods of the classes, e.g. `v->area()` can be used where `vector * v` is initialized with `vector * v = new vector;`, for example.

__Tip:__ Delete the allocated class with `~` if `new` has been used.

#### Helper function for a class: needs to be defied _before_ the call
If you call a function that was defined outside the class, you _may_ get the error that the function `was not declared in this scope`. For example, the following code will throw error:
```
class CC{
	public:
		CC(){
			call_func();
		}
};

void call_func(){
	//code here
};
```
The solution is simply to move the function _before_ the class definition (in particular, before the function was called). This situation may not arise if the function definition was written in a header file like this `void call_func();` and this file contained the implementation of it, and that header file was included in this file.


#### Static variables
Static variables defined within a class are shared by _all_ instances of the class and are defined _outside_ the class. Their values are the same across _all instances_ of a class. For example,
```
class vector(){
	static int count;

	vector(){
		count ++;
	}
}
// Set outside the class description
int vector::count = 0;

int main(){
	vector a;
	// cout = 1
	vector b;
	// cout = 2
	vector c;
	// cout = 3
}
```

A variable that is to be the same across all instances of a class and is _not_ meant to be changed anywhere in the code can be defined using `const static` _inside_ the class.

## Overloading
Using the same name to mean different things, based on indicative properties such as datatype, number of arguments, etc.

#### Using namespaces
Same variable names can be defined in different namespaces
```
namespace first {
   int a;
   int b;
}

namespace second {
   double a;
   double b;
}

int main () {
   first::a = 2;
   first::b = 5;

   second::a = 6.453;
   second::b = 4.1e4;
}
```

To avoid writing the namespace along with the variable, declare the variable along with namespace like this
```
#include<iostream>
using namespace std::cout;
using namespace std::endl;
```
Later, we can just write `cout << 'Hi' << endl` instead of the long `std::cout << 'Hi' << std::endl`.

#### Function name overloading
Depending on the datatype of the function, we can define different implementations of the same function name

```
double test (double a, double b) {
   return a + b;
}

int test (int a, int b) {
   return a - b;
}

int main () {
   double   m = 7,  n = 4;
   int	    m = 7,  n = 4;
}
```

#### Overloading within a class
__Special case:__ constructor is a typical function and can be overloaded.
The implementation on the constructor can change based on the number and type of input variables to the constructor.
```
class testc {
	public:
		double a;
		double b;
		
		// no input
		testc(){
			a = 5;
			b = 5;
		}

		// two double inputs, second one optional
		testc(double p, double q=3){
			a = p;
			b = q;
		}
		
		// one int and one double input, second one optional
		testc(int p, double q=4){
			a = p;
			b = q;
		}
};
int main(){
	testvec t1;		//t1.b = 5
	testvec t2(5.0); 	//t2.b = 3
	testvec t3(5);		//t3.b = 4
	testvec t4(2,1);	//t4.b = 1	
}
```

__Good practice:__ to _not_ use multiple constructors. Instead, use single constructor and specify default values.

#### Operator overloading

Operators can be overloaded, for example, to define `+` between two classes.

## C++ project structure
[See appropriate section of link](http://www.ericbrasseur.org/cppcen.html?i=1)
The idea is to keep the following separate: 
  - The header files with definitions only (e.g. `vector.hpp`)
  * Functions have to be defined _before_ they are called. This is especially important when the header and implementation files are not separate.
  - The implementations of methods defined in the header files (e.g. `vector_implementations.cpp`)
  - The test code that uses rest of the code base, but does not contain main implementations (e.g. `testing_code.cpp`)

This way, we can generate an object file called `vector_implementations.o` from the header and the implementation using
```
g++ -c vector_implementations.cpp
```

At this point, the file `vector_implementations.cpp` is unnecessary. However, we still need `vector.h`.

Later, link the object file while compiling the test code using
```
g++ testing_code.cpp vector_implementations.o -o output_exec
```
and run the output executable using
```
./output_exec
```

* Keep the namespace, class definition, public variables, and public method definition with `.hpp` files.
For example the following header file `allvectors.hpp` contains
```
class vector {
public:
   double x;
   double y;

   double surface();
};

class morevector {
public:
   double x;
   double y;

   double surface();
};
```
* Keep the implementations of the methods defined within the classes in `.cpp` files. In those file, import the corresponding header files. The full name of the methods need to be used (e.g. `double <class_name>::method_name()` etc).

For example, the following `working_with_vectors.cpp` contains
```
using namespace std;
#include "allvectors.hpp"

double vector::surface() {
   double s = 0;

   for (double i = 0; i < x; i++)
   {
      s = s + y;
   }

   return s;
}
```

* Keep the executable code (the one with `int main()`) in another `.cpp` file.
For example, the file `testing_the_code.cpp` contains
```
using namespace std;
#include <iostream>
#include "allvectors.h"
int main () {
   vector k;

   k.x = 4;
   k.y = 5;

   cout << "Surface: " << k.surface() << endl;

   return 0;
}
```

#### More 
* Functions have to be defined _before_ they are called. This is especially important when the header and implementation files are not separate.
* Floating point arithmetic error: subtraction of the floating point number that are very close to each other produces a large roundoff error. For example, the following code
```
double u =  5.7;
double p_x = 0.1;
double a = (p_x + u) - u;
std::cout << "diff: " << p_x - a << std::endl;
```
produces an error of about `2e-16`, which is pretty large compared to the machine-epsilon of `double`.
To avoid such incidents, 
 1. Reformulate the algorithm to avoid risky subtraction and division
 1. Increase the precision temporarily while adding and subtracting:
```
double a = ((long double) p_x + (long double) u) - (long double) u;
```
 1. Finally, reduce the number of operations to mitigate the effect of round-off errors.

**Solution:** Use `long double`. The datatype `double` is accurate up to `16` significant digits. So, numbers larger than 16 digits are read incorrectly.
[Here](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html) is an interesting explanation where the provide example of something like this happening.

A [post](https://scicomp.stackexchange.com/questions/26370/improve-numeric-stability-of-subtraction-in-c) explains it very well in comparison to Matlab's trick to avoid such error.
* Inheritance, polymorphism etc
* `std::vector<double>`
* `this` is used to denote the pointer to the instance of the class, eg. for `delte this;`. However, it is rarely used. Another usage is to get information from the base class while calling from within a derived class.
* 

## Arrays
* Single array can be defined directly as
```
double arr[] = {1, 3, 4, 5};
double 2dArr[] = {{1,2},{2,3},{5,6}};
```
* Allocate memory using
```
double * arr = new double[5];
```
and can be freed using 
```
delete[] arr;
```

__Caution:__ 2D array cannot be allocated if the second index is a variable, i.e.
```
int i, j;
double * arr = new double[i][j];
```
is invalid!!!
* The name of the array is the pointer to the array, i.e. 
```
int a2[] = {1, 2, 3};
int * arr;
arr = a2;	// arr is now a2
```
So, we can pass the array name to a function that takes pointers, like this
```
void afunc(double * arr){
...}
void main(){
    double a2[] = {1, 2, 3};
    afunc(a2);
}
```


### Vector-related help

* For Matlab-like operations, the most useful datatype is `Array` by the `Eigen` library. You can do point-wise multiplication that you cannot do with datatypes like `Vector`.
* For 2D row vectors, we will use `Array<double, 1, 2>`.

* C++ datatype `std::vector<ttype>` can contain an array of datatypes of any kind, but it cannot do element-wise operation like vectors do.

For example, the following assignment won't work
```
vector<int> v={2, 3, 7};
vector<int> u;
u = v;
```
You need to `push_back()` each entry into `u`:
```
vector<int> u;
for (int i; i<v.size(); ++i){
    u.push_back(v[i]);
}
```

However, the datatypes like `Eigen::Vector2d` etc from the library `Eigen` can do assignment easily. 
```
Vector2d v = {1, 4};
Vector2d u = v;
```
Unfortunately, with `Eigen`, we cannot construct `Vector2d` of non-numeric objects, which `std::vector` allows, e.g. `vector<myClass> v`.

* The `std:vector` must have a well-defined size before we assign values to them directly. 
The following code will throw `Segmentation fault` error:
```
vector<int> w;
w[0] = 1;
```

Instead, specify the size while defining using `vector<int> w(2);` or using a `resize()` function after defining like `w.resize(2);` After that, the assignment `w[0] = 1` will be valid.


#### Removing elements from the vector: `.erase()` **done using pointers**

Create a vector using
```
vector<double> v;
v.push_back(1.5);
v.push_back(3.4);
v.push_back(4);
v.push_back(6);
v.push_back(5);
v.push_back(4);
v.push_back(2.4);
std::cout << v << std::endl;
std::cout << v.size() << std::endl;
```

To remove the value `3.5` (`v[1]`) from  the vector, do
```
v.erase(v.begin()+1);
```
Here, `b.begin()` is the pointer to `v[0]` and `+1` takes to pointer to the next value in the vector.

* Remove a consecutive list of values using
```
v.erase(v.begin()+2, v.end()+5);
```

* Remove multiple elements (use `remove()` followed by `erase()` instead, see below):
To remove all elements bigger than `3`, do:
```
for (auto i = v.begin(); i != v.end(); ++i) {
    if (*i > 3) {
	v.erase(i);
	--i;
    }
}
```
The `i--` is essential to go with `.erase()` since `v` changes size during the loop and  `v.end()` means nothing. Therefore `i` can run over the current `v.end()` and output garbage.

* Note that  you can do pointer algebra with `int`. For example,
```
int steps = i - v.begin();
```
is valid in the code above.

* Use `remove()` to remove multiple elements faster and ignoring the for loop:
[The *erase-remove idiom*](https://en.wikipedia.org/wiki/Erase%E2%80%93remove_idiom)
The `remove()` function from `#include<algorithm>` does _not_ create a final reduced vector, but simply shifts the values forward after removing elements, resulting in an unspecified size of vector, which actually contains the final (reduced) vector in its first few places.
We need to `erase(begin_ptr, end_ptr)` those last few garbage values using the output of `remove()`, which is the _beginning_ (`begin_ptr`) of these garbage values and `v.end()`, the original _ending_  `end_ptr` of  the garbage values.

The output of the `remove()` function is the starting points of the first item _after_ the final reduced array.

#### Eigen with OPENMP
It seems that there is some error (why?) if I use Eigen with `-fopemmp`. So, turn of Ei-gen's own parallelism using
```
#define EIGEN_DONT_PARALLELIZE
```
in the beginning of the file containing `int main()`.

# Another C++ tutorial

## Compilation process
* __preprocessing__: replacing all occurrence of `.h` files in the `.c` files by their code
* __compiling__: convert all `.CXX` files into machine-readable _object_ files with extension `.o`
* __linking__: link libraries to object files and generate the combined _executable_ files
* __building__: a general term for the complete process of preprocessing, compiling, and linking 
* __header file__: with `.h` extension
* __source file__: with `.CXX` extension

## C++ directory structure
```
.
 |-- CMakeLists.txt
 |-- build
 |-- include
 |   \-- includefile.h
 \-- src
     |-- includefile.cpp
     \-- mainapp.cpp
```

The built files will be stored in the `build` directory.

## Compilers
When building programs in C++, use `g++`, which is a counterpart of `gcc` that compiler C files. `gcc` (or `g++`) does preprocessing, compilation, assembly, and linking in that order.

###`gcc` (and therefore `g++`) options:

* `gcc` does _not_ allow grouping of single-letter options. (i.e `-dv` is different from `-d -v`)
* It matters where (in which order) the `-l` option is specified.
* To stop the building process before linking, use `-c` option. It does only compilation and assembly, but _not_ linking. It produces `.o` files.
* Use `-S` to stop after compilation. Does not assemble. It produces `.s` files that are to be used in assembly.
* Use `-E` to stop after preprocessing. Does not compile. The preprocessed source code is sent to stdout.
* `-###` to print the commands executed to perform the building process, but does not run the steps. `-v` actually run the steps in addition to printing them.

## CMake tutorial

`cmake` generates a `MakeFile` automatically so that you don't have create it yourself. 
Howeve, we need to write a `CMakeLists.txt` file with all the information.

[link](http://derekmolloy.ie/hello-world-introductions-to-cmake/)

* `set(VARNAME value)` sets a variables. For example, `set(CMAKE_BUILD_TYPE Release)`. To call the variable, use `${VARNAME}`.

* Add compiler of linker flags:

 1. Define the flags first, using
```
SET(GCC_COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
SET(GCC_COVERAGE_LINK_FLAGS    "-lgcov")
```
 1. Later, set the flags by appending them to the existing flags, like this:
```
SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}")
SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")
```

* Set the location of header files (`.h`) using `include_directories(include)`.

* The output executable file name, and the source file(s) that are used to generate the executable are set using `add_executable()`. 

For example, `add_executable(testapp mainapp.cpp)` generates the executable `testapp` from the file `mainapp.cpp` (when there is no header file involved).

When header files are involved, we have different ways to incorporate them in building the executable file.
 1. Add `include_directories(include)` beforehand
 1. Specify all source files individually like this
```
set(SOURCES src/mainapp.cpp src/Student.cpp)
add_executable(testapp ${SOURCES})
```
 1. Specify all source files using wildcard
```
file( GLOB SOURCES "src/*.cpp")
add_executable(testapp ${SOURCES})
```

#### Typical `CMakeLists.txt` file:

```
cmake_minimum_required(VERSION 2.8.9)
project(Project_Name)

#Bring the headers, such as includefile.h into the project
include_directories(include)

#Can manually add the sources using the set command as follows:
#set(SOURCES src/mainapp.cpp src/Student.cpp)

#However, the file(GLOB...) allows for wildcard additions:
file(GLOB SOURCES "src/*.cpp")

add_executable(testStudent ${SOURCES})
```



# Using an older version of gcc

- In Ubuntu 22.04 the default gcc is version 11 (`gcc -v`). To install `gcc-10` use
```
sudo apt install gcc-10 g++-10
```

- Check now available compilers using
```
dpkg --list | grep compiler
```

- To see the symlink for the current `gcc` using
```
ln -l /usr/bin/gcc
ln -l /usr/bin/g++
```

- Install all available versions as an alternative to `gcc`

```
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11
```

- Configure which one will be in use using
```
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
```
and selecting the older choice `gcc-10` and `g++-10`.

- Verify that the desired version is in use using
```
gcc -v
g++ -v
```

# nvcc with Ubuntu 22.04

- Installing `nvidia-cuda-toolkit` doesn't help.

- Installing `nvidia-cuda-toolkit-11.6` from the website has the issue that `sudo apt install -y cuda` fails due to missing package.

- Download missing package from
https://packages.ubuntu.com/impish/amd64/liburcu6/download
install using `sudo dpkg -i liburcu6`

- Compiling with `nvcc` produces gcc compatibility error

- Calling `nvcc` with full path `/usr/local/cuda-11.6/bin/nvcc test.cu` works!

# C/C++ compilation troubleshooting

* `error: No rule to make target: .../libname.so`
Multiple occurrence of the .so file. Find multiple installs of the library using
`apt search libname` and remove more than one instances.

Another way to find the packages responsible for the required files is using `apt-file search`:

`apt-search file /usr/lib/x86_64-linux-gnu/openmpi/lib/libmpi.so`

The method still did not work, so I had to manually create symbolic links pointing to them with:

cd /usr/lib/x86_64-linux-gnu/openmpi/lib/
ln -s libmpi.so.* libmpi.so
ln -s libmpi_cxx.so.* libmpi_cxx.so

* The DSO missing from command line message:

Easiest fix: use `-lpthread` when `${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU"`. I.e., in the CMakeLists.txt, modify the appropriate lines to

Common ways to inject this into a build are to export LDFLAGS before running configure or similar like this: 
```
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    #set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lpthread")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
```

Another fix: export a environment variable like this:
```
export LDFLAGS="-Wl,--copy-dt-needed-entries"
```

As a workaround it's possible to switch back to the more permissive view of what symbols are available by using the option `-Wl,--copy-dt-needed-entries`.

Sometimes passing `LDFLAGS="-Wl,--copy-dt-needed-entries"` directly to make might also work.

details: [link](https://stackoverflow.com/questions/19901934/libpthread-so-0-error-adding-symbols-dso-missing-from-command-line)
This error is displayed when the linker does not find the required symbol with it's normal search but the symbol is available in one of the dependencies of a directly specified dynamic library.
In the past the linker considered symbols in dependencies of specified languages to be available. But that changed in some later version and now the linker enforces a more strict view of what is available. The message thus is intended to help with that transition.

