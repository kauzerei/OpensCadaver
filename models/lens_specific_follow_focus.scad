use <../import/publicDomainGearV1.1.scad>
//porst color reflex 55/1.4
$fa=1/1;
$fs=1/1;
gear(0.8*3.1415926,95,12,68);
  
difference() {
#  translate([0,0,-6])cylinder(d=69,h=12);
  translate([0,0,-7])cylinder(h=14,d=63);
  for( a=[0:360/30:360]) rotate([0,0,a])translate([0,-2,-7]) cube([33,4,14]);
}