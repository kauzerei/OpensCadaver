include <../import/BOSL2/std.scad>

$fs=1/2;
$fa=1/2;
bsl=1/100;

part="left";//[right,left]

x=42;
y=72;
z=20;
c=2;

d=4;
od=8;
w=2;
o=10;

ib=round_corners(square([x,y],center=true),cut=c,method="chamfer");

difference(){
  offset_sweep(offset(ib,delta=w), height=z, bottom=os_chamfer(width=c));
  up(w) offset_sweep(ib, height=z, bottom=os_chamfer(width=c));
  up(z/2+w/2)yrot(90)cylinder(d=d,h=x);
  up(z/2+w/2)yrot(-90)cylinder(d=od,h=x);
  if (part=="left") {
    translate([-x/2-w-o,-y/2+o,-bsl]) cube([x+w,y,z+2*bsl]);
    translate([x/2-o-bsl,y/2-2*c,-bsl]) cube([o+w+2*bsl,2*c+w+bsl,z+2*bsl]);
  }
}
