include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
part="skookum";//[skookum,regular]
w=part=="skookum"?4:3;
intersection() {
xrot(90) linear_extrude(height=8,center=true,convexity=3) {
  right(17)rect([38,40],rounding=2);
  right(32) circle(14);
}
union() {
  linear_extrude(height=32,center=true,convexity=3) {
    rect([4,w],chamfer=0.5);
    right(11) rect([6,w],chamfer=0.5);
    right(24) back(1.5) polygon([for (i=[1:1:6]) (rect([8,w+1],chamfer=[0.5,0.5,0.5,0]))[i]]);
    right(32) rot(180) back(1.5) polygon([for (i=[1:1:6]) (rect([8,w+1],chamfer=[0.5,2,0.5,0]))[i]]);
    right(41) rect([10,w-1]);
  }
  for (m=[[0,0,0],[0,0,1]]) mirror(m)up(16+w/2)linear_extrude(height=w,center=true) {
    right(17)rect([38,8],chamfer=2);
  }
}
}