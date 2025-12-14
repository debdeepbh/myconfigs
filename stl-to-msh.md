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
