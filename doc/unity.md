# Unity 3D
 Install linpng12 from AUR.
 
 Install unity 3d from AUR. Note: The package build is 11GB  after makepkg -s and creates a .sh file and a directory. Instead of pacman -U, use the generated install script as there will be no .xi file to install. This is also an advantage since these files can be moved to another partition and launched. These are 3GB long.
 
 Watched tutorial on game rolling the ball on their official site.
 Lessons:
 A "is Trigger" object with a "Rigid body" component is a "Dynamic collider" and uses more resources.
 A "is Trigger" object without"Rigid body" component is a "Static  collider" is ideal. Setting "kinemetic" field will give you desired result.
 
