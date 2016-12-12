#Device Driver

###Problem Statement

The objective of this project was to write a device driver to
read mouse events (left click and right click) and adjust the
brightness of the screen. If a user presses left mouse button,
then the brightness of the screen should decrease and if user
presses right mouse button, then the brightness of the screen
should increase.

###Solution

1. Enter superuser mode using:
    `sudo su`
2. Create a device file using the command:
    `mknod /dev/myDev c 89 2`    
3. Change the access permission using:
    `chmod a+r+w /dev/myDev`    
4. Go the folder containing bright.c using:
    `cd <path to bright.c>`    
5. Compile it using make command:
    `make`    
6. Load the module using insmod command:
    `insmod bright.ko`   
   NOTE: If a module is already loaded, we need to unload it first using:
    `rmmod <module_name>.ko`
7. Compile the test file using:
    `gcc test.c -o test`    
8. Run the executable using:
    `./test`    
9. The driver is now up and running.
   Left click would decrement the brightness while right click would increment it.    
10. Now unload the module using:
     `rmmod bright.ko`    
11. Done :)