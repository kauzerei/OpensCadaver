//Sennheiser hd-25 nut. The ones on the Thingiverse have simplified geometry, I wanted an exact copy
$fa=1/2;
$fs=1/2;
arr=[13,15,17,19,21];
difference() {
  union() {
    for (i=[0:4]) translate([0,0,i]) cylinder(h=1,d=arr[i]);
    translate([0,0,5]) cylinder(d1=23,d2=25,h=1);
    translate([0,0,6]) cylinder(d=7.6,h=1.4);
    translate([0,0,7.4]) cylinder(d=5,h=5);
    translate([0,0,12.4]) intersection() {
      cylinder(d=5,h=2);
      cube([3.7,5,4],center=true);
    }
  }
  translate([0,0,1]) cylinder(d=2.5,h=20);
  translate([8.3,0,4]) cylinder(d=1.5,h=5);
}