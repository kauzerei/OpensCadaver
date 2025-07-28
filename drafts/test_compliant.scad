include <../import/BOSL2/rounding.scad>
include <../import/BOSL2/std.scad>

p=[[0,0],[0,50],[50,100],[50,0]];
po=round_corners(path=p,method="chamfer",joint=12);
pi=round_corners(path=offset(p,delta=-5),method="chamfer",joint=3);
linear_extrude(height=10) difference(){
  polygon(smooth_path(po,size=1,closed=true));
  polygon(smooth_path(pi,size=1,closed=true));
}