//Rubber handle for steadicam
$fa=1/1;
$fs=0.5;
use <knurling.scad>
difference() {
  union() {
    perpendicular_knurl(h=52,d=30,n=32,a=45,depth=1,fraction=3,precision=0.1);
    translate([0,0,48]) cylinder(d1=30,d2=34,h=4);
    translate([0,0,52])intersection() {
      cylinder(h=8,d=26);
      cube([26,16,16],center=true);
    }
  }
  cylinder(h=60,d=22);
}