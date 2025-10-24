include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;
thickness=8;
base_width=100;
base_depth=70;
height=20;
rounding=4;
eyelet_d=4;
eyelet_w=20;
eyelet_gap=0.5;
wall=3;

module servo_gear() {

}

module servo_mount() {

}

module top() {

}

module bottom() {
  linear_extrude(height=thickness) difference() { //base
    r=rect([base_width,base_depth],rounding=rounding);
    polygon(r);
    polygon(offset(r,r=-thickness));
  }
  for (m=[[0,0,0],[0,1,0]]) mirror(m) difference() { //eyelets
    hull() {
      translate ([0,base_depth/2-thickness/2,height]) ycyl(d=eyelet_d+2*wall,h=thickness);
      translate ([-eyelet_w/2,base_depth/2-thickness,thickness]) scale([1,1,0]) cube([eyelet_w,thickness,1]);
    }
    translate([0,base_depth/2-thickness/2,height]) ycyl(d=eyelet_d,h=thickness+2*bsl);
  }
}

down(height) bottom();