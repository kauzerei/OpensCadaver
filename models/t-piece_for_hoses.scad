/* Project: OpenAutoLab, but will do for any liquid-related projects 
connects three hoses together */
$fn=64/1;
id=6;
od=9;
hole=4;
block=14;
teeth_depth=1;
teeth_length=4;
teeth_number=5;
holding_length=teeth_length*teeth_number;
module piptik() {
  for (i=[0:teeth_number-1]) {
    translate([0,0,i*teeth_length])cylinder(d1=id,d2=id-teeth_depth,h=teeth_length);
  }
}
difference() {
  union() {
    rotate([90,0,0])cylinder(d=od,h=block,center=true);
    rotate([90,0,0]) translate([0,0,block/2]) piptik();
    rotate([-90,0,0]) translate([0,0,block/2]) piptik();
    translate([0,0,od/2]) piptik();
    cylinder(d=od,h=od/2);
  }
  rotate([90,0,0])cylinder(d=hole,h=2*holding_length+block+0.02,center=true);
  cylinder(d=hole,h=holding_length+od/2+0.01);
}
    