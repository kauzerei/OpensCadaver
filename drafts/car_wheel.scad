include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;

*difference() {
  cyl(d=12.6,h=5.5,texture="trunc_pyramids",tex_depth=0.4,tex_reps=[32,3]);
  cylinder(d=9,h=5.6,center=true);
  translate([0,0,-5.5/2+1.2])cylinder(d=11,h=5.6);
}

rim_d=11;
wheel_d=13;
wheel_w=5.5;
cap_d=9;
cap_w=0.8;
lip=0.6;
ch_v=1;
ch_h=2;
tex_depth=0.4;

path=[
[cap_d/2,0],
//[wheel_d/2-ch_v,0],
[wheel_d/2,0],
//[wheel_d/2,ch_h],
[wheel_d/2,wheel_w],
[rim_d/2-lip,wheel_w],
[rim_d/2,wheel_w-lip],
[rim_d/2,cap_w],
[cap_d/2,cap_w]
];

intersection() {
rotate_sweep(path);
cyl(d=wheel_d-tex_depth*2,h=wheel_w,texture="trunc_pyramids",tex_depth=tex_depth,tex_reps=[32,3],center=false,chamfer1=0.6,chamfang1=70);
}

tyre=[
[1,1,0,0,1,1,0,0],
[1,1,0,0,1,1,0,0],
[1,1,1,1,1,1,0,0],
[1,1,1,1,1,1,0,0],
[0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0],
[0,0,1,1,1,1,1,1],
[0,0,0,0,1,1,0,0],
[0,0,0,0,1,1,0,0],
[0,0,1,1,1,1,1,1],
[0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0],
[1,1,0,0,1,1,1,1],
[1,1,0,0,1,1,0,0],
[1,1,0,0,1,1,0,0],
];
*cyl(d=20*10/PI, h=10, chamfer=0,
    texture=tyre, tex_reps=[60,1], tex_depth=0.4,style="concave");
    
