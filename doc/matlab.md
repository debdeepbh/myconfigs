# Matlab parfor tutorial

* In the gui mode, increase set the default number of workers to 20 (from 12)
* Start the local pool with `parpool('local', 16)` to start 16 workers
* Run your code next 
* Close the pool with `delete(gcp('nocreate'))`

* To load `.mat` files in parallel, call `load()` in an external function (file), e.g. `load_ext.m`
```
function str = load_ext(filename)
	str = load(filename);
end
```
Later, call the file from within parfor:
```
parfor i=1:10
	str = load_ext(strcat('data/file_'), num2str(i), '.mat');
	% extract the varibles from the struct
	matrix_1 = str.matrix_1;
	do_something_with(matrix_1);
end
```



