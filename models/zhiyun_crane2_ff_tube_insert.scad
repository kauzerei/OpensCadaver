$fn=128;
difference() {
  union() {
    cylinder(d=18.9,h=19);
    cylinder(d=19.4,h=1);
    translate([0,0,18])cylinder(d=19.4,h=1);
  }
    translate([0,0,-0.1])cylinder(d=14.9,h=19.2);
    translate([-1,0,-0.1])cube([2,10,20]);
}