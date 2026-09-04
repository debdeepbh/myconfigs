# Openmp help

## Requirements
* Add `#include<mpi.h>` 
* Compile with `-fopenmp`
* Compute the time taken by the executable by running it with `time -p` prefix in shell

## Information
[Guide](https://bisqwit.iki.fi/story/howto/openmp/) 
[Thirty minute guide](https://www.linuxtoday.com/blog/mpi-in-thirty-minutes.html)

```
omp_get_num_threads()
omp_get_max_threads()
omp_get_thread_num()
omp_get_num_procs()
```

* Check if you are using the right number of processors:
```
grep 'processor.*:' /proc/cpuinfo | wc -l
```
* The number of threads are optimized (usually) when it is the number of processors.
With  2 cpus and 2 threads per cpu, the optimum value is 4, the total number of (virtual) cpus.


* Set environment variables different from the default value for maximum possible threads using
```
export OMP_NUM_THREADS=4
```
This will be reflected in `omp_get_max_threads()`.

This can also be set within the code with
```
#pragma omp parallel num_threads(4)
```

* Setting the value outside the code is recommended for flexibility and transparency.

* Setting `num_threads()` is usually unnecessary as the default value (=#cpus) is usually the best.

* Setting `num_threads()` manually to a fixed number is _not_ flexible. If necessary, can be expressed in terms of `omp_get_max_threads()`.


### Repetition of a block of code
```
#pragma omp parallel
{
	code_1();
}
```
Here, `code_1()` will be executed `omp_get_max_threads()` number of times.

* You can specify how to many threads will be used for that particular parallelism by
```
#pragma omp parallel num_threads(7)
```

* If you want a part of the code block to execute only once, use `single`
```
#pragma omp parallel
{
	// this will run multiple times
	code_1();

	// this will run only once
	code_2();
}
```

### For loop:

- The long-hand version is
```
#pragma omp parallal
{
    #pragma omp for
    for(int n=0; n<10; ++n){
	    print(" %d", n);
}
}
``` 

This first creates `omp_get_num_threads()` number of threads. Then, the statement `#pragma omp for` picks a value of `n` and *assigns* the associated `printf` task to one of threads. Not that this is **not** a nested multithreading. The outer `pragma` creates a parallel space and the next `pragma` assigns tasks to each of the threads.

* This is same as writing simply the following shortcut:
```
#pragma omp parallel for
for(int n=0; n<10; ++n){
	printf(" %d", n);
}
```
Note that there is no order in which the code inside the omp directive runs.

* The `ordered` part of the code is executed in the same order of the `for` loop: (note the two occurrences of `#pragma` to specify which part of the code is ordered):
```
#pragma omp parallel for ordered schedule(dynamic)
for(int n=0; n<10; ++n){
	// do other unordered things
	code_1();

	// now the ordered part
	#pragma omp ordered
	code_2();
}
```

Here, `code_1()` will be executed in an arbitrary order, but will stop and wait if the *previous* chunks of `code_2()` are unfinished.

* If the for loop is a sum type, we can do
```
int sum=0;
#pragma omp parallel for reduction(+:sum)
for(int n=0; n<1000; ++n) {
	sum += table[n];
}
```
This avoids the sharing of the variable `sum` by multiple threads. Instead, different threads place their partial sums while running and in the end communicates and adds those partial sums up.



*  Running parts of the code in parallel
```
 #pragma omp sections
 {
   { Work1(); }
   #pragma omp section
   { Work2();
     Work3(); }
   #pragma omp section
   { Work4(); }
 }
```
This code indicates that any of the tasks Work1, (Work2 + Work3), and Work4 should run in parallel, but that Work2 and Work3 must be run in sequence. Each work is done exactly once, *as opposed to* the following
```
 #pragma omp parallel
 {
	Work();
 }
```
which runs `Work()` multiple times.


* `critical` sections prevent multiple threads from accessing the critical section's code at the same time, thus only one active thread can update the data referenced by the code.
```
#pragma omp parallel 
{
 	code_1();

    #pragma omp critical
	code_2();
}
```

Compare this with `ordered`: 
```
#pragma omp parallel for ordered schedule(dynamic)
for(int i =0; i<10; ++i)
{
	// runs in arbitrary order 
 	code_1();

	// runs in arbitrary order, but _NOT_ concurrently by various threads
	// i.e. waits until another random thread is finished running
    #pragma omp critical
	code_2();

	// runs in the same order as the for loop
    #pragma omp ordered
	code_3();
}
```

### Nested for loop
[source](http://ppc.cs.aalto.fi/ch3/nested/).
Parallelizing of nested for loops is generally discouraged. The only case when it is advised is when the outer loop has too few elements compared to the number of threads available.

* Defining parallel twice does nothing, and increase the runtime due to overhead:
```
// bad code example
#pragma omp parallel for
for (int i = 0; i < 3; ++i) {
    #pragma omp parallel for
    for (int j = 0; j < 6; ++j) {
        c(i, j);
    }
}
```
This code does not do anything meaningful. “Nested parallelism” is disabled in OpenMP by default, and the second pragma is ignored at runtime: a thread enters the inner parallel region, a team of only one thread is created, and each inner loop is processed by a team of one thread. The end result will look, in essence, identical to what we would get without the second pragma — but there is just more overhead in the inner loop:

* For perfectly nested (one `for` after another) **rectangular** loops (i.e., the second index does not depend on the first index), we can use `collapse(level)`:

```
 #pragma omp parallel for collapse(2)
 for(int y=0; y<25; ++y)
   for(int x=0; x<80; ++x)
   {
     tick(x,y);
   }
```
Here, `2` represents the level of nesting.

In this case, two loops are converted into a single one and total iterations are distributed among the threads, *as if* the code reads

```
 #pragma omp parallel for
 for(int z=0; z<25*80; ++z)
     tick(z/80, z%80);
```

* Force enable nested parallelism using `num_threads(level);` in the beginning where `level` is the nested levels you want to enable parallelism in.
```
omp_set_nested(1);
#pragma omp parallel for num_threads(2)
    for(int n=0; n<size; ++n){
	//std::cout << "Current thread level: " << omp_get_level() << std::endl;
	//std::cout << "Started " << omp_get_num_threads() << std::endl;
	sinTable[n] = n * n + 5;

#pragma omp parallel for num_threads(2)
	for (unsigned i = 0; i < 200; i++) {
	    //std::cout << "Current thread level: " << omp_get_level() << std::endl;
	    //std::cout << "Started " << omp_get_num_threads() << std::endl;
	    sinTable[i + n] = 5 * i * n;
	}
}
```

* Check the current nested thread level using `omp_get_level()`. 
* Specify `num_threads()` so that more than available threads do not pop up, since the default number of level-1 nested parallelism produces `omp_get_num_threads()`^2 threads, which are much bigger than available threads, leading to showdown.

* Did not find any advantage in enabling nested parallelism (even after setting the `num_threads()` to be `sqrt(omp_get_num_threads())` to avoid going over total available threads) since the overheads for the inner loop adds to a delay.

### Static vs dynamic schedule for `for` loop

[explanation](http://jakascorner.com/blog/2016/06/omp-for-scheduling.html)

* `schedule(static)` divides the work between thread at *compile-time*, so it is pre-determined which thread will get which iterations of the `for` loop
* `schedule(dynamic)` divides the work between thread at *runtime*, so assignment of iterations to threads is random at runtime

* The static scheduling type is appropriate when all iterations have the same computational cost.
* `schedule(dynamic)` is more appropriate when the loop iterations are expected to take variable amount of time. The expectation is that runtime of all threads will average out and will result in smaller total runtime, whereas in the `static` case, some threads might finish their work and wait around for other threads.

* Increasing the chunk size makes the scheduling more static, and decreasing it makes it more dynamic. [source](http://www.inf.ufsc.br/~bosco.sobral/ensino/ine5645/OpenMP_Dynamic_Scheduling.pdf)

* `schedule(static)` is faster compared to `dynamic` for equal-length jobs due to less overhead when the computation costs are equally distributed.

* OpenMP guarantees that if you have two separate loops with the same number of iterations and execute them with the same number of threads using static scheduling, then each thread will receive exactly the same iteration range(s) in both parallel regions. 

* `guided` schedule reduces the chunk length over time, providing a balance between the two. You can set the minimum chunk length possible.

# OpenMPI

- Install on ubuntu with
```
sudo apt-get install libopenmpi-dev
```
and see the version using `mpic++ --showme:version`.


# mpi4py  python with mpi

- Start with 

```
from mpi4py import MPI
comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()
print('rank', rank, flush=True)
```

- Run python script with

```
mpiexec -np 4 python3 filename_with_mpi.py
```

- Run a for loop over [1,2,...,N] using
```
for p in range(rank, N, size):    # mpi
	# do stuff with index p, which would be unique for each rank, and would cover 1 to N
```

- You can gather the output from different ranks into a single list using

```
result = comm.gather(some_list, root=0)
```
Then it will look like `result  = [ some_list_1, some_list_2, ..., some_list_size ]`.
If `some_list` is itself a list, we can join them using

```
joined_list = [j for i in result for j in i]
```

