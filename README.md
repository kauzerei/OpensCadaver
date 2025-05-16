# OpensCadaver
The collection of 3d-models made by me in OpenSCAD.  
## No idea about OpenSCAD?
In case you are here just for custom STLs, here's some short explanation what's it all about and how to get the STLs.  
OpenSCAD is software for modelling solids, for example for 3d-printing.  
Instead of clicking in screen as in most of the CAD software like FreeCAD, one describes a model with human-readable code in OpenSCAD's own language. That's what is written in `.scad`-files.  
The designer of the model can make it parametric, which means that some properties (thickness of walls in boxes, diameters of holes for the screws in multipart objects, etc) can be changed without rewriting the code.  
**Customizer** is part of OpenSCAD, that simplifies changing those parameters without knowing the OpenSCAD's language or understanding model's internal workings.  
If you want to have an STL with some parameters differing from default, open the `.scad` file with OpenSCAD and you will typically see the Customizer window on the right. Turn it on in Window submenu if it does not appear by default. Change the values however you like (what you see on screen may take long time to update, depending on complexity of moded) and press **F6** to build the solid (may take some time) and **F7** to save it.
## Dependencies?
Openscad. Some of the models may rely on latest features of OpenSCAD, not available in stable builds, so if something doesn't work, try using openscad-nightly or build from master branch on github if you are hardcore.  
Some of the models are using BOSL2 library, it is a submodule of this repo, so just do ```git submodule update --init``` in order to have it in `import/BOSL2` to have those models generated.  
Autogenerating script does that automatically if needed. It works only on Linux.  
## Repo structure
`models` openscad models written by me.  
`import` external files such as STLs of scanned objects or other people's models and libraries which are used. All information is either in files themselves or in `import/README.md`.  
`stl` not part of the repo anymore. This directory is created when running `generate_stl.sh` and all generated parts are saved there.  
## generate_stl.sh
Currently works on Linux only. A script that takes names of the models (or just `stl/*`) as an argument and writes STLs with the same names into `stl` directory.  
If a model is multipart it outputs several STLs for each part.  
## About structure of scad files
If an object is multipart, a variable `part` is declared near the beginning, which contains the name of default part. After variable declaration there is a comment in Customizer-compatible format, which contains all parts' names.  
```
part="subpart1";//[subpart1,subpart2,NOSTL_assembly]
```
If the name of the part starts with `NOSTL`, such part will not be automatically processed by `generate_stl.sh` script. With NOSTL I usually mark part assemblies or other debug aids, that should not (or even can not) be 3d-printed and are used for visualization only.  
I typically don't use `$fn` to make models smooth, `$fa=1` and `$fs=0.5` are typically used instead, which allows not to specify larger $fn for larger circles. The drawback of this approach is that axes do not necessarily align with 4 points on the circle, unlike when setting `$fn` to a multiple of 4, which can lead to some tiny steps on transitions between circles and straight segments in some models.  
In order to avoid z-fight in preview, I declare a small value `bissl=0.01` to offset otherwise coplanar faces on Bool operations, *des isch so um des Flächle a bissl zu verschieba, gell?*   