//Model of a sony np-f battery mount, can be used for connecting power to device which uses such batteries or to make your device accept those batteries
//Project: camera stab
use <battery_holder_double_spring.scad>
use <worm.scad>;
$fs=1/2;
$fa=1/1;
part="interface";//[interface,holder]
module cutouts(cuts=2.15) {
  linear_extrude(height=cuts,convexity=8) shapes();
}

module shapes() {
  polygon([[5.35,47.49],[1.45,51.39],[1.45,66.64],[3.65,66.64],[3.65,60.24],[5.35,60.24]]);
  translate([0,-37.58])polygon([[5.35,47.49],[1.45,51.39],[1.45,66.64],[3.65,66.64],[3.65,60.24],[5.35,60.24]]);
  translate([2.4,32.74])square([2.95,10.05]);
}

module positive(width=38.14,cuts=2.15) {
  difference() {
    translate([0,0,0])cube([width,70.14,5.35]);
    translate([cuts,0,0.01])rotate([0,-90,0])cutouts(cuts+0.01);
    translate([width+0.01,0,0.01])rotate([0,-90,0])cutouts(cuts+0.01);
    translate([-0.01,-0.01,-0.01])cube([6.58+0.01,1.91+0.01,5.35+0.02]);
    translate([width-6.58,-0.01,-0.01])cube([6.58+0.01,1.91+0.01,5.35+0.02]);
    translate([2.4,0,3])rotate([-90,0,0])cylinder(h=9,d=3);
    translate([width-2.4,0,3])rotate([-90,0,0])cylinder(h=9,d=3);
  }
}

if (part=="interface") difference() { 
  mirror([0,0,1])positive();
  worm(path=[[2.4,0,-3],[2.4,8,-3],[2.4,10,-1],[5,12,-1],[5,70,-1]])sphere(1.5);
  worm(path=[[38.14-2.4,0,-3],[38.14-2.4,8,-3],[38.14-2.4,10,-1],[38.14-5,12,-1],[38.14-5,70,-1]])sphere(1.5);
  for (x=[-5,5]) for (y=[10:10:60]) translate([x+38.14/2,y,-6]) cylinder(d=3.5,h=7);
}
if(part=="holder") difference() {
holders(battery_l=65, battery_d=19, wall=1.6, contact_depth=1.6, contact_width=1.6, n=2);
for (y=[-5,5]) for (x=[9:10:60]) translate([x,y+21.2,-0.1]) cylinder(d1=2,d2=6,h=2);
}