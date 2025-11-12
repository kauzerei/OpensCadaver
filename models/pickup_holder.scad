include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;
wall=0.8;
h=14;
l=64;
d=38;
cutout=true;
edge=2;

difference() {
  union() {
    linear_extrude(height=d,center=true,convexity=4) {
      difference() {
        union() {
          rect([h+wall,l+2*wall],anchor=RIGHT);
          rect([2+2*wall,88],anchor=RIGHT);
        }
        union() {
          rect([h,l],anchor=RIGHT);
          left(wall)rect([2,70],anchor=RIGHT);
        }
      }
    }
    yflip_copy() fwd(78/2) xcyl(d=8,h=6);
  }
  yflip_copy() fwd(78/2) xcyl(d=4,h=50);
  if (cutout) {
    down(d/2-wall)cube([h+wall+bsl,l-2*edge,d-edge-wall],anchor=RIGHT+BOTTOM);
  }
}

down(d/2) linear_extrude(height=wall) {
  rect([h,l],anchor=RIGHT);
  left(wall)rect([2,70],anchor=RIGHT);
}
