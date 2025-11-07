include <../import/BOSL2/std.scad>
wall=0.8;
difference() {
  linear_extrude(height=38,center=true,convexity=4) {
    difference() {
      union() {
        rect([12+wall,60+2*wall],anchor=RIGHT);
        rect([2+2*wall,88],anchor=RIGHT);
      }
      union() {
        rect([12,60],anchor=RIGHT);
        left(wall)rect([2,70],anchor=RIGHT);
      }
    }
  }
  yflip_copy() fwd(78/2) xcyl(d=4,h=50);
}