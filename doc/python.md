# matplotlib help

* Import using 
```
import matplotlib.pyplot as plt
```

* Equal axis
```
plt.axis('scaled')
```
* Axis limit
```
plt.xlim(-2e-3, 2e-3)
```
* Save to file
```
t = 5;
ind = ('%05d' % t)
output_filename = 'data/'+ind+'.png'

plt.savefig(output_filename, dpi=150)
```

* To open the plot in the background (and not show), add the following (in addition to `import matplotlib.pyplot as plt`)
```
import matplotlib
matplotlib.use('Agg')
```

# Python Numpy array

* Convert numpy array to python list using `.tolist()`

* Creating zero arrays (or `ones`) need to be specified with double parenthesis
```
a = np.zeros((5,7))
```

- Convert column matrix to array
```
M  = np.squeeze(np.asarray(M))
```

* Matrix-matrix multiplication of numpy arrays are done using `@` operator or using `a.dot(b)`
```
a = np.array([ [1, 3], [4, 5] ])
b = np.array([ [2],[5])
c = a @ b # output: [ [17], [33] ]
```

- Converting a 2d matrix to a 1d vector
	- Use `np.concatenate()`:
	```
	A = [ [1,2], [2,3], [3,4]]
	B = np.concatenate(A)
	# B = [1,2,2,3,3,4]
	```

* Matrix-vector row-wise multiplication is not automatic. We need to convert the rank-1 array (size `(3,)`) into a rank-2 array (size `(3,1)`) using `[:,None]` like this:
```
A = np.array([
    [1,2,3], 
    [4,5,6], 
    [7,8,9]
    ]) 

v = np.array([0, 1, 2])

row_A_v = A * v[:, None]
```

Note that `v` is of size `(3,)` whereas `v[:, None]` is of size `(3,1)`.

* Convert asymmetric list to a numpy array (matrix) by padding zero

```
b = np.zeros([len(a),len(max(a,key = lambda x: len(x)))])
for i,j in enumerate(a):
    b[i][0:len(j)] = j
```

* max-min: use `np.amax()` with `axis=` 0 or 1 or _without_ for the flattened array

* Find where an element `i` appears: use `np.where(Array == i)`, which is a 2d object. Use index `[0]` to get the rows, and `[1]` to get the columns.
Caution: the output is a numpy array (`array([3, 2, 5])` etc). Covert it to usual python list (i.e. `[3, 2, 5]`)using `.tolist()`

* Appending (concatenation):
  - Numpy array: `original_array = np.append(original_array, appendage, axis = 0)` appends `appendage` as a set of rows (`axis = 0`) at the end of original_array. **Caution:** This is _not_ in-place, so we need to over write the `original_array`.
  - Python list: `list_1.append(row)` is an in-place operation.
  * We can append as columns or  rows using `np.c_[]` or `np.r_[]`, e.g.
    ```
    np.c_[
	    np.linspace(-1., 1., 1000),
	    np.random.uniform(-0.5, 0.5, 1000)
	    ]
    ```
   creates a (1000,2) matrix.


* Copying a variable into another creates only a memory reference
```
u = [ 3, 4, 5]
v = u
v[0] = 0
print(u[0]) # Output: 0 !!!
```

Same goes for classes
```
Class Cl(object):
	__init__(self, a):
		self.a = a

## Later
cl_list = []
cl_list.append(Cl(5))
cl_list.append(Cl(5))

cl_list[0].a = 7
print(cl_list[1].a) # output: 7 !!!
```

The solution is to use `deepcopy()`

* Deleting array elements is _not_ in-place. This is to avoid resizing the array while deleting.
A good idea is to delete multiple items at once and copy it to a new array.
```
index = [2, 3, 6]
new_a = np.delete(a, index)
```

- Joining sublists into a single list using double list comprehension `[j for i in Array for j in i]`:

```
arr = [[[1, 2], [2, 3]], [[6, 7], [6, 9]]]

>> [j for i in arr for j in i]

[[1, 2], [2, 3], [6, 7], [6, 9]]

```
# Python inline if then else

- use `(if a then b else c)`
```
[((n-1) if n>0 else 0) for n in array]
```


# Python class
* See the list of attributes of a class using `.__dict__.keys()`

# Python plotting

## 3d scatter plot

* Note that we use `ax.scatter` instead of `plt.scatter` (for 2d plots with `import matplotlib.pyplot as plt`)
```
from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure()
ax = Axes3D(fig)
ax.scatter(X, Y, Z, s = 10,  linewidth = 1 )
ax.text(X, Y, Z, str(99))
```

* **Aspect ratio:** the 3d plot messes up the aspect ratio. We _cannot_ set the aspect ratio to be equal using `ax.set_aspect('equal')`  (even though we should).
This feature is not implemented yet (what??!!) as so we add the following snippet to make it happen:
```
extents = np.array([getattr(ax, 'get_{}lim'.format(dim))() for dim in 'xyz'])
sz = extents[:,1] - extents[:,0]
centers = np.mean(extents, axis=1)
maxsize = max(abs(sz))
r = maxsize/2
for ctr, dim in zip(centers, 'xyz'):
    getattr(ax, 'set_{}lim'.format(dim))(ctr - r, ctr + r)

ax.set_box_aspect((1, 1, 1))
```
Alternatively, set x, y, and z ranges manually so that the length of the ranges are the same and do  `ax.set_box_aspect((1, 1, 1))`:
```
 XYZlim = [-3e-3, 3e-3]
 ax.set_xlim3d(XYZlim+1e-3)
 ax.set_ylim3d(XYZlim - 0.2e-3)
 ax.set_zlim3d(XYZlim + 3e-3)
 ax.set_aspect('equal')
ax.set_box_aspect((1, 1, 1))
```


[Source](https://stackoverflow.com/questions/8130823/set-matplotlib-3d-plot-aspect-ratio/19933125)
This snippet applies to `ax`, so we can convert it into a function `def fix_aspect(ax):` and call it.

* In 2D, the aspect ration can be set using
```
plt.axis('scaled')
```
and specify the axes limits using 
```
plt.xlim(a, b)
plt.ylim(c, d)
```

**Caution:** `plt.axis('scaled')` goes _before_ setting `plt.xlim()` and `plt.ylim()` for the boundaries to remain faithful.


## Plotting a bunch of lines
Plotting each line using a `for` loop is too slow. Use `LineCollection` and `Line3DCollection` instead.
The format of the data has to be in the following format:
```
[
 [ [start_x_1, start_y_1, start_z_1], [end_x_1, end_y_1, end_z_1] ], 
 [ [start_x_2, start_y_2, start_z_2], [end_x_2, end_y_2, end_z_2] ], 
 [ [start_x_3, start_y_3, start_z_3], [end_x_3, end_y_3, end_z_3] ], 
...
 [ [start_x_N, start_y_N, start_z_N], [end_x_N, end_y_N, end_z_N] ]
]
```
where there are `N` lines that start with `start` and ends at `end`. 
Note that The array has rank 3.

Example of such construction:
Given two `(N,3)` arrays `P_start` and `P_end`, to draw `N` lines between `P_start[i]` and `P_end[i]` in 3D, construct
```
ls = [ [p_start, p_end] for p_start, p_end in zip(P_start, P_end) ]
```


* Plot using
```
import matplotlib.pyplot as plt
from matplotlib.collections import Line3DCollection

lc = LineCollection3D(ls, linewidths=0.5, colors='b')

ax = plt.gca()
ax.add_collection(lc)

plt.show()
```

** Caution: ** For 2D plotting with `LineCollection`, you **must** add a scaling command like
```
ax.autoscale()
```
for the plots to show. Otherwise, no line will be printed. (weird bug?)

**Note:** that the collection added to `ax` (and not to `plt`).

# Python import module

* See the current directory from where the script runs
```
import sys
print(sys.path[0])
```

* Add a path from where to import `.py` files later
```
sys.path.append(full_dir_path)
```

* Go back one directory from the current path
```
prev_dir = os.path.dirname(sys.path[0])
```

* To add a path that is in a subdirectory `bar` within a directory that in one level up:
```
import sys, os
# previous directory of the current script
prev_dir = os.path.dirname(sys.path[0])
# print(prev_dir)
sys.path.append(prev_dir)
# sys.path.append(os.path.join(prev_dir,'bar'))
```




# Python parallel processing with multiprocessing:

Say we have a function called `write_img(t)` that takes integer values. 
The for loop
```
for t in range(starting, ending):
	write_img(t)
```
can be replaced by
```
from multiprocessing import Pool
a_pool = Pool()
a_pool.map(write_img, range(staring, ending))
```

* If the argument of the function is not a number, we can feed an iterator (array, tuple, list, etc) of the input parameters
```
def myfunc(obj):
	x = obj.x
	y = obj.y
	# some stuff with x and y
	return obj2

from multiprocessing import Pool
input_list = []
for i in range(10):
	obj_i = # some code here ...
	input_list.append(obj_i)

a_pool = Pool()
output_obj2_list = a_pool.map(myfunc, input_list)
```

* If the function takes more than one input, we can use `zip()` to combine input variables or create a partial function to convert it into a one-input function on the fly using `partial` from `functools` (which is included in the default python installation)
```
def fun2(x, y):
	return z = x * y

from functools import partial
fun1 = fun2(x, 5)

from multiprocessing import Pool
a_pool = Pool()
output_list = a_pool.map(fun1, range(10))
```

* If you get the error 
```
AttributeError: 'NoneType' object has no attribute 'pack'
```
then use
```
pool.close()
```
after the multiprocessing is over to delete the pool.

* Use `pathos.multiprocessing` (`pip3 install pathos`) instead of usual multiprocessing to use parallel processing on partial functions (to use on functions with multiple inputs)
```
from pathos.multiprocessing import ProcessingPool as Pool
```

# Python vispy


[Basic tutorial] (https://github.com/ipython-books/cookbook-code/blob/master/featured/06_vispy.ipynb)

[A github collection of tutorials] (https://github.com/liubenyuan/vispy-tutorial)

* Install `vispy`
```
pip3 install vispy
```

* Install a backend:
```
pip3 install pyqt5
```
or
```
pip3 install pyglet
```
For jupyter notebook use `ipynb_webgl`.
Note: for whatever reason, backend `egl` hangs the system and produces nothing.

* See the available backend using
```
import vispy
print(vispy.sys_info())
```

* Plot a test plot
```
import numpy as np
import vispy.app
# vispy.app.use_app('ipynb_webgl')
# vispy.app.use_app('pyglet')
vispy.app.use_app('pyqt5')
from vispy import plot as vp
fig = vp.Fig(show=False)
fig1 = fig[0, 0]
fig1.plot(np.random.uniform(-0.5, 0.5, 1000) ,marker_size=0)
# fig1.plot(range(10000),marker_size=0)
fig.show(run=True)
```

# Graph connectivity in python using `networkx`
Example:
```
import networkx as nx

import matplotlib.pyplot as plt
import numpy as np

G = nx.Graph()
bonds = np.array([ [0,1],[0,2],[0,5], [1,2], [2,5],[3,4]])

G.add_edges_from(bonds)

print(nx.is_connected(G))
print(nx.number_connected_components(G))
print(list(nx.connected_components(G)))

# nx.draw(G, with_labels=True)
# plt.draw()
# plt.show()
```

