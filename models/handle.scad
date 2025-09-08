include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

width=20;
back=smooth_path([[0, -15], [34, -15], [75, -4], [100, -7]],splinesteps=40);
front=smooth_path([[0, 25], [12, 20], [25, 23], [33, 22], [47, 27], [57, 25], [72, 30], [83, 28], [100, 33]]);

zvals=[for (i=[0:1:100]) i];

bs=[for (i=zvals) lookup(i,back)];
fs=[for (i=zvals) lookup(i,front)];

function slot(b,f,w)=move([b,0],rect([f-b,w],rounding=w/2,anchor=LEFT));

shapes=[for (i=zvals) slot(bs[i],fs[i],width)];

//skin(shapes,z=zvals,slices=1);
//echo([for (i=zvals) 0.5*(bs[i]+fs[i])]);
path_sweep(circle(d=1,$fn=64),
           [for (i=zvals) [0.5*(bs[i]+fs[i]),zvals[i]]],
           scale=[for (i=zvals) [fs[i]-bs[i],30]],
           tangent=[for (i=zvals) [0,1,0]],
           caps=1,
//           texture="bricks_vnf",tex_reps=[10,40],tex_depth=.1
           );