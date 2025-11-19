include <../import/BOSL2/std.scad>
$fn=32;

xflip_copy() right(1) difference() {
  union() {
    cube([26,40,1]);
    cube([16,30,2]);
  }
  right(8) back(18) linear_extrude(height=5,center=true,convexity=4) keyhole(12,2.5,5);
  right(21)back(5) cylinder(d=2,h=5,center=true);
  right(5)back(35) cylinder(d=2,h=5,center=true);
}