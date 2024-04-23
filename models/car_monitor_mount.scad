//mount for the cheap car composite-video dispay
//Project: camera rig
//sorry, it's not parametric, because I don't see a sensible way of parameterizing those clips

$fs=1/1;
$fa=1/1;
bissl=1/100;
module single_clip() {
  linear_extrude(6) union() {
    square([5,2.5]);
    square([2.5,6]);
  }
}
module quad_clip() {
  translate([23,-6,30])mirror([1,0,0])single_clip();
  translate([0,-6,30])mirror([0,0,0])single_clip();
  translate([23,-6,0])mirror([1,0,0])single_clip();
  translate([0,-6,0])mirror([0,0,0])single_clip();
}
quad_clip();
difference() {
  hull() {
    cube([23,2,36]);
    translate([0,18,18])rotate([0,90,0])cylinder(d=36,h=10);
  }
 // translate([2,18,18])rotate([0,90,0])cylinder(d=12,h=20,$fn=6);
  translate([-bissl,18,18])rotate([0,90,0])cylinder(d=4,h=10);
  translate([3,18,18])rotate([0,90,0])cylinder(d=8,h=20,$fn=6);
  for (a=[45:90:360]) translate([3,18+sin(a)*10,18+cos(a)*10])rotate([90,0,90]) cylinder(d=8,h=20,$fn=6);
  for (a=[45:90:360]) translate([-bissl,18+sin(a)*10,18+cos(a)*10])rotate([90,0,90]) cylinder(d=4,h=10);
}