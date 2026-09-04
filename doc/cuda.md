# CUDA NVIDIA with C++

## Installation

- If using properietary GPU driver from Nvidia (like nvidia-driver-495), installing nvidia-cuda-toolkit changes it to 'Using a manully installed driver'.

* Install `CUDA Toolkit`: 
Follow instruction on [sit](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal) to download the `.deb` and install for ubuntu version.

Using `apt-get`  (about 2GB of installation)
```
sudo apt-get install nvidia-cuda-toolkit
```
gives the error on compilation with nvcc: `error: attribute "__malloc__" does not take arguments`.

* Check your gpu info with 
```
nvidia-smi
```
You can find your CUDA version here.

- Find the number of cuda cores in your graphics card

```
nvidia-settings -q CUDACores -t
```

## Jargon

- Device memory = GPU memory
- Host memory = CPU memory
- SM = streaming multiprocessor

## Running C++ codes
[quick tutorial](https://developer.nvidia.com/blog/even-easier-introduction-cuda/)
- Save the code with `.cu` extension
- Compile with `nvcc` or with path `/usr/local/cuda-11.6/bin/nvcc`
- Run the executable with regular  `./`


# CUDA NVIDIA with python

## Installation on Xubuntu-22.04

### Install liveUSB with

1. wifi on
2. check `updating packaging while installing`
3. check `install proprietary drivers`

### If `Additional Drivers` is disabled

```
sudo apt install nvidia-384
```

This  will enable the drivers listed in the page.

### In `Additional Drivers`:

1. Use `nvidia-510` (proprietary, tested)
1. Restart

### Install cuda from website

1. Run scripts in sequence from [site](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64)

For cuda 11.7, the scripts are

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
```

1.  Restart 

### `nvcc`

Even after installing commands like `nvcc --version` won't be available. You would need to add the cuda installation path to your `.bashrc`. For cuda version 11.7, we need to add to `.bashrc`:

```bash
export PATH="/usr/local/cuda-11.7/bin:$PATH"
```

For using nvcc in compiling C++ code, 

```bash
export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH"
```

1. Source `.bashrc`

### Installing pytorch

1. uninstall older torch: `pip3 uninstall torch`
2. Use script generated from [pytorch website](https://pytorch.org/get-started/locally/)
by selecting the platform, cuda version etc.

For cuda 11.7 version (which is required for 3070 and 3080 graphic cards), pytorch 11.6 works as well.

```
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116
```

3. Test pytorch works with cuda by running

```python
import torch
print('cuda available in torch:', torch.cuda.is_available())
```

## Showing stats

* Check your gpu info with 

```
nvidia-smi
```

You can find your CUDA version here.

- Find the number of cuda cores in your graphics card

```
nvidia-settings -q CUDACores -t
```

## cupy as an alternative to numpy

* Install `cupy` (for CUDA version `11.1`, check [website](https://cupy.dev/) for other versions)
```
pip3 install cupy-cuda111
```

* Sample `cupy` code
```
import numpy as np
import cupy as cp
import time 

# define a name for memory  pool to extract information later
mempool = cp.get_default_memory_pool()

x_gpu = cp.random.randint(0, 256, (10980, 10980)).astype(cp.uint8)

# get memory info, cross check with `nvidia-smi` in bash
print('size of x_gpu', x_gpu.nbytes)                          
print('used', mempool.used_bytes())             
print('total mempool', mempool.total_bytes())           

## numpy counterpart
x_cpu = cp.random.randint(0, 256, (10980, 10980)).astype(cp.uint8)

## perform an operation
s = time.time()
x_cpu *= 5
e = time.time()
print('numpy', e - s)

### CuPy and GPU
s = time.time()
x_gpu *= 5
# wait for gpu to finish before going to the next line
cp.cuda.Stream.null.synchronize()
e = time.time()
print('cupy', e - s)
```

* **Note:** `cupy` arrays cannot exceed the memory of the GPU. However, GPUs have more than one `devices` with equal memories (see with `nvidia-smi`). Make sure to use them both to take advantage of all the memory.

The default device is `0`.  Change the device to `1` with
```
cp.cuda.Device(1).
```
and all the arrays defined henceforth will be stored in the device `1`. The arrays in other device stays.

* Clear an array from memory with `del x` or `x = None`. After this, we can reassign the array `x`.
However, this does not get reflected in `nvidia-smi` since the allocated memory is not freed immediately. To manually clear _unused_ memory, do `mempool.free_all_blocks()`, which id observed in `nvidia-smi`.

* Install `nvidia-profiler` to use `nvprof` with code

## numba

- install with
```
pip3 install numba
```

- Try the code the runs in serial
```
import numpy as np
from timeit import default_timer as timer

def pow(a, b, c):
    for i in range(a.size):
         c[i] = a[i] ** b[i]

def main():
    vec_size = 100000000

    a = b = np.array(np.random.sample(vec_size), dtype=np.float32)
    c = np.zeros(vec_size, dtype=np.float32)

    start = timer()
    pow(a, b, c)
    duration = timer() - start

    print(duration)

if __name__ == '__main__':
    main()
```

- Now, with `numba`
```
import numpy as np
from timeit import default_timer as timer
from numba import vectorize

@vectorize(['float32(float32, float32)'], target='cuda')
def pow(a, b):
    return a ** b

def main():
    vec_size = 100000000

    a = b = np.array(np.random.sample(vec_size), dtype=np.float32)
    c = np.zeros(vec_size, dtype=np.float32)

    start = timer()
    c = pow(a, b)
    duration = timer() - start

    print(duration)

if __name__ == '__main__':
    main()
```


## OPENMP in C++
[slides](https://ukopenmpusers.co.uk/wp-content/uploads/uk-openmp-users-2018-OpenMP45Tutorial_new.pdf)
* Get the number of devices in the host using `omp_get_num_devices()` function.
Use `#pragma omp target` to run code on target devices.

