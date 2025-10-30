include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;
height=15;
id=5;
depth=0.5;
ds=[13,13.5,14,14.5,15,15.5,16,16.5,17];

for (i=[0:1:len(ds)-1]) right(cumsum(ds)[i]+i) difference() {
  cylinder(h=height,d=ds[i]);
  down(bsl)cylinder(h=height+2*bsl,d=id);
  up(height-depth) linear_extrude(height=depth+bsl) back(2)text(str(ds[i]),font="Quicksand:style=Bold",size=4,halign="center",valign="bottom");
}