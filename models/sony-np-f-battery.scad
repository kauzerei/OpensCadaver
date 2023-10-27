//Model of a sony np-f battery mount, can be used for connecting power to device which uses such batteries or to make your device accept those batteries
//Project: camera stab
use <battery_holder.scad>;
use <worm.scad>;
$fs=0.5/1;
$fa=1/1;
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
difference() {
  union() {
    mirror([0,0,1]) positive(); //sony np-f mount on the bottom
    holders(diameter=19.07,number=2,wall=1.57,floor=0); //18650 on the top
  }
*  translate([35.74,-10,-10])cube([100,100,100]);
*  translate([2.4,-10,-10])cube([100,100,100]);
//  corners=[[35.74,0,-3],[35.74,10,-3],[35.74,0,-3]];
  worm(path=[[2.4,0,-3],[2.4,9,-3],[2.4,15,3],[2.4,0,3]])sphere(1.5);
  worm(path=[[35.74,0,-3],[35.74,9,-3],[35.74,15,3],[35.74,0,3]])sphere(1.5);
}