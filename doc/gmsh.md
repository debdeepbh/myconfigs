# gmsh with python

* Examply annulus
```
import gmsh
gmsh.initialize()
msh_file = 'meshdata/msh_test.msh'

scaling = 1

# - the first 3 arguments are the point coordinates (x, y, z)
# - the next (optional) argument is the target mesh size close to the point
# - the last (optional) argument is the point tag (a stricly positive integer
#   that uniquely identifies the point)
# gmsh.model.occ.addPoint(0, 0, 0, meshsize, 1)

gmsh.model.occ.addCircle(0, 0, 0, scaling, 1)
gmsh.model.occ.addCircle(0, 0, 0, scaling/2, 2)

gmsh.model.occ.addCurveLoop([1], 1)
gmsh.model.occ.addCurveLoop([2], 2)
gmsh.model.occ.addPlaneSurface([1, 2], 1)

# obligatory before generating the mesh
gmsh.model.occ.synchronize()
# We can then generate a 2D mesh...
gmsh.model.mesh.generate(2)
# write to file
gmsh.write(msh_file)

# close gmsh instance, as opposed to gmsh.initialize()
gmsh.finalize()	
```

* With pygmsh [due to the lack of documentation, hard to figure out options, so I won't use it much]

Originally, the mesh can be generated using `with` statement like
```
with pygmsh.geo.Geometry() as geom:
    circle1 = geom.add_circle([0,0], radius=scaling, mesh_size=meshsize)
    mesh = geom.generate_mesh()
```
However, the non-`with` version should be `geom = pygmsh.geo.Geometry()` but it doesn't when fed into `.generate_mesh()`. Instead use `model` approach:
```
geometry = pygmsh.geo.Geometry()
model = geometry.__enter__()

circle1 = model.add_circle([0,0], radius=scaling, mesh_size=meshsize)
geom.generate_mesh()
```

* extrude this way
```

gmsh.model.occ.addPoint(x_min, y_min, 0, meshSize=meshsize, tag=1)
gmsh.model.occ.addPoint(x_min+length_x, y_min, 0, meshSize=meshsize, tag=2)
gmsh.model.occ.addLine(1,2, tag=1)
# extruding the line: dimension 1, tag 1 i.e., (1,1)
# numElements is the number of steps by which we extrude, heights is the scaling factor
gmsh.model.occ.extrude([(1, 1)], 0, length_y, 0, numElements=[ny], heights=[1])
```

To feed the geometry to pygmsh, 


# Converting stl to msh

`meshio convert` does not work, some error related to binary conversion.
Instead, open with `gmsh` directly `gmsh mesh_10-repaired.stl -o mesh.geo`, or with

```geo
Merge "mesh_10-repaired.stl";
//+
Surface Loop(1) = {1};
//+
Volume(1) = {1};
```

and open it in gmsh. Then select `Refine mesh` within gmsh to increase the number of faces and then export to gmsh with desired mesh size.

# Repairing mesh

Open the mesh in OpenCAD with `mesh` workbench. Fix mesh option will allow you to remove repeated faces, reorient normal, patch holes, and smoothen out the shape (by shrinking it a little bit, you can rescale it up).

Export it as an `stl` file, then open with `gmsh` and create an `msh` file from it. (`meshio convert` will not work it seems).
