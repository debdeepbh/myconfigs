# HDF5 dataset

* `rank` is the number of dimension of a data array
* Read any `.h5` file using `h5dump` (part of `hdf5-tools` package on Ubuntu). e.g.
```
h5dump filename.h5
```
* To see the headers `-H`:
```
h5dump -H filename.h5
```
* To see all the header of the group `mygroup` with `-g`
```
h5dump -g 'mygroup' -H filename.h5
```

* To print the dataset `mygroup/mydata` with `-d`
```
h5dump -d 'mygroup/mydata' filename.h5
```


### HDF5 dataset in C++
* In `C++` on Ubuntu, install
```
sudo apt-get install libhdf5-serial-dev hdf5-tools
```

* To compile files with `#include<H5Cpp.h>`, compile with _both_ `-lhdf5_cpp` and `-lhdf5_serial` parameters and supply the location of the header file (`locate H5Cpp.h`) with `-I`. e.g. in `makefile`, add
```
CPPFLAGS += -I /usr/include/hdf5/serial/ -lhdf5_serial -lhdf5_cpp
```

### HDF5 dataset in Matlab

* In Matlab, the pathname for a dataset within a file _has_ to start with `/`, but not in C++.

* Create group within a file before adding a dataset within the group. 
```
H5::H5File fp("output/filename.h5", H5F_ACC_TRUNC);
fp.createGroup("/FirstLevel");
// now you can add datasets like "/Firstlevel/D1" etc
```

### HDF5 dataset in python

* Install the package `h5py`
* **Caution:** Always convert the dataset to `np.array()` before reading from or writing to a `h5py` file.

* Example reading:
```
import h5py
f = h5py.file(filename, "r")

PosArr = []
for name in f:
	pos = np.array(f['P00001/Pos'])
	PosArr.append(pos)
```

