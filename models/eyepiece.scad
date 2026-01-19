include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;
mount=[58,49];
box=[81,56];
mount_offset=[7.7,0];
center_offset=[4,-4];
cutouts=[[40,10],[10,30]];
cutouts_pos=[[17,-25],[40,-5]];
cutouts_h=12;
air=0.5;
wall=1.6;
hole=3;
lens_dist=57;
lens_d=80;

linear_extrude(height=wall) difference() {
  offset(r=air) square(box,center=true);
  translate(mount_offset) {
    for (tr=rect(mount)) translate(tr) circle(d=hole);
    offset(r=-2)rect(mount);
  }
}
difference() {
  linear_extrude(height=lens_dist+wall,convexity=4) difference() {
    offset(r=air+wall) square(box,center=true);
    offset(r=air) square(box,center=true);
  }
  translate([center_offset[0],center_offset[1],lens_dist])cylinder(d=lens_d+2*air,h=wall+bsl);
  for (i=[0:1:len(cutouts)-1]) linear_extrude(height=cutouts_h) translate(cutouts_pos[i]) square(cutouts[i],center=true);
}