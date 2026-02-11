include <../import/BOSL2/std.scad>

$fa=1/4;
$fs=1/4;

//path=smooth_path([[0,0],[-12,-5],[-7,20],[0,18]],size=0.8);
loop_shape=[[0,0],[-12,-5],[-7,20],[0,18]];
loop_path=subdivide_path(round_corners(loop_shape,radius=[0,3,3,0]),maxlen=1,closed=false);
nshapes=len(loop_path);
ntrans=floor(nshapes/3);
shapes=[each [for (i=[0:1/ntrans:1]) rect([6-2*i,5-i],rounding=1+i*0.9)],
        each repeat(rect([4,4],rounding=1.9),nshapes-2*ntrans-2),
        each [for (i=[1:-1/ntrans:0]) rect([6-2*i,5-i],rounding=1+i*0.9)]];
tangents=path_tangents(loop_path);
//echo(tangents[0]);
//rotations=[for (vector=tangents) rot(from=[1,0,0],to=vector)];
//oriented_shapes=[for(i=[0:1:nshapes-1]) move(loop_path[i],rot(from=[0,0,1],to=tangents[i],p=path3d(shapes[i])))];
oriented_shapes=[for(i=[0:1:nshapes-1]) move(loop_path[i],rot([0,0,90-atan2(tangents[i][0],tangents[i][1])],p=rot([0,90,0],p=path3d(shapes[i]))))];
skin(oriented_shapes,slices=1);
//echo(rotations[0]);
echo(oriented_shapes[0]);
//skin(profiles=rot());

//stroke(loop_path);

//echo(nshapes);
//echo(len(shapes));
//echo(len(tangents));
//echo(repeat(nshapes,rect([4,4],rounding=1.9)));
//echo(repeat([[4,4],[5,5]],8));
//shapes=[for(a=[0:1:360]) ];