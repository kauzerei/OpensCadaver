include <../import/BOSL2/std.scad>

$fa=1/4;
$fs=1/4;

//path=smooth_path([[0,0],[-12,-5],[-7,20],[0,18]],size=0.8);
loop_shape=[[0,0],[-12,-5],[-7,20],[0,18]];
loop_path=subdivide_path(round_corners(loop_shape,cut=[0,4,2,0],k=0.5,method="smooth"),maxlen=1,closed=false);
nshapes=len(loop_path);
ntrans=floor(nshapes/3);
shapes=[each [for (i=[0:1/ntrans:1]) rect([6-2*i,5-i],rounding=1+i*0.9)],
        each repeat(rect([4,4],rounding=1.9),nshapes-2*ntrans-2),
        each [for (i=[1:-1/ntrans:0]) rect([6-2*i,5-i],rounding=1+i*0.9)]];
tangents=path_tangents(loop_path);
oriented_shapes=[for(i=[0:1:nshapes-1]) move(loop_path[i],rot([0,0,90-atan2(tangents[i][0],tangents[i][1])],p=rot([0,90,0],p=path3d(shapes[i]))))];
skin(oriented_shapes,slices=1);

rotate([-90,0,0])translate([0,0,-3])linear_extrude(height=26) {
  circle(d=6);
}

//stroke(loop_path);
