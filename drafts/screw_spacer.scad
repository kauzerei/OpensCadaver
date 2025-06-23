// Used for making shelves out of OSB and metal angles
$fa=1/1;
$fs=1/2;
bissl=1/100;
thickness=1;
hole=7;
height=7;
head=10;
id=5;
od=12;
difference() {
  union() {
    cylinder(h=height-thickness,d=od);
    cylinder(h=height,d=hole);
  }
  translate([0,0,-bissl])cylinder(d1=head,d2=id,h=(head-id)/2);
  cylinder(d=id,h=height+bissl);
}