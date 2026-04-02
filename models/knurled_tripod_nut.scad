include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
part="counternut";//[counternut,pusher,switch_offset,screw_holder]
if (part=="counternut") render() difference() {
  cyl(h=11, d=17, texture="ribs", tex_size=[2,1],tex_depth=1,tex_taper=0, anchor=BOTTOM);
  cylinder(h=11,d=7);
  up(6) cylinder(h=5,d=12.5,$fn=6);
}