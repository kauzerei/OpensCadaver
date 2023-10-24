//Model of a sony np-f battery mount, can be used for connecting power to device which uses such batteries or to make your device accept those batteries
//Project: camera stab
$fn=64;
module cutouts() {
  linear_extrude(height=2.15,convexity=8) shapes();
}
module shapes() {
  polygon([[8,47.49],[4.1,51.39],[4.1,66.64],[6.3,66.64],[6.3,60.24],[8,60.24]]);
  translate([0,-37.58])polygon([[8,47.49],[4.1,51.39],[4.1,66.64],[6.3,66.64],[6.3,60.24],[8,60.24]]);
  translate([5.05,32.74])square([2.95,10.05]);
}
module positive() {
  difference() {
    cube([38.14,70.14,8]);
    translate([2.15,0,0])rotate([0,-90,0])cutouts();
    translate([38.14,0,0])rotate([0,-90,0])cutouts();
    translate([0,0,2.65])cube([6.58,1.91,5.35]);
    translate([31.56,0,2.65])cube([6.58,1.91,5.35]);
    translate([2.3,0,5.7])rotate([-90,0,0])cylinder(h=10,d=3);
    translate([35.8,0,5.7])rotate([-90,0,0])cylinder(h=10,d=2.8);
  }
}
difference() {
  positive();
  translate([35.8,14,0]) rotate([45,0,0]) cylinder(h=16,d=2.8,center=true);
  translate([2.3,14,0]) rotate([45,0,0]) cylinder(h=16,d=2.8,center=true);
}