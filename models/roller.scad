include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;
part="roller";//[roller,handle]
roller_d=19;
width=50;
bearing_od=16;
bearing_id=5;
bearing_h=4;
lip=1;
slack=2.5;
handle_thickness=6;
handle_length=80;
handle_width=30;
module roller() {
  difference() {
    cyl(d=roller_d,height=width,chamfer=1);
    cyl(d=bearing_od-2*lip,h=width+bsl);
    zflip_copy()up(width/2-bearing_h+bsl)cyl(d=bearing_od,h=bearing_h,anchor=BOTTOM);
  }
}
module handle() {
  path=[[-width/2+bearing_h,0],
        [-width/2-handle_thickness,0],
        [-width/2-handle_thickness,-roller_d],
        [-handle_width/2+handle_thickness,-roller_d],
        [-handle_width/2+handle_thickness,-roller_d-handle_length],
        [handle_width/2-handle_thickness,-roller_d-handle_length],
        [handle_width/2-handle_thickness,-roller_d],
        [width/2+handle_thickness,-roller_d],
        [width/2+handle_thickness,0],
        [width/2-bearing_h,0]];
  shape=smooth_path(path,relsize=0.08);
  difference() {
    path_sweep2d(rect([handle_thickness,handle_thickness],chamfer=handle_thickness/8),shape);
    difference() {
      xcyl(d=roller_d,h=width+2*slack);
      xcyl(d=bearing_id,h=width);
      xflip_copy() right(width/2)xcyl(d1=bearing_id+2*lip,d2=bearing_id+2*lip+2*slack,h=slack,anchor=LEFT);
    }
  }
}
if (part=="roller") roller();
if (part=="handle") handle();