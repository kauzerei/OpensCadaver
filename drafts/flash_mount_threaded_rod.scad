//A part to fix camera shoe to a threaded rod
//Used for holding camera in the air for 3d-scanning
//Motivation: bottom shape of the camera is uninterrupted
$fa=1/1;
$fs=1/2;
bissl=1/100;
shoe_narrow=12;
shoe_wide=18;
shoe_depth=17;
shoe_thickness=1.6;
thread=6;
hex=12;
nut_h=5.5;
wall=4;
layer=0.2;
difference() {
  union() {
    translate([-shoe_wide/2,-shoe_depth/2,0])cube([shoe_wide,shoe_depth,shoe_thickness]);
    translate([-shoe_narrow/2,-shoe_depth/2,shoe_thickness]) cube([shoe_narrow,shoe_depth,nut_h+wall-shoe_thickness]);
  }
  translate([0,0,nut_h+layer])cylinder(d=thread, h=wall);
  rotate([0,0,90])translate([0,0,-bissl])cylinder(d=hex, h=nut_h,$fn=6);
}