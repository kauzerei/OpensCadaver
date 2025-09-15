//Part of a vacuum cleaner, that holds the removable container

include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fa=1/2;
$fs=1/2;
bsl=1/100;

button_w=30;
button_l=24;
button_h=8;
button_r=10;

piptik_d=8;
piptik_h=4;
piptik_o=13;
clearance_d=14;
clearance_h=6;

hook_l=20;
hook_a=38;
offset=2;
triangle_l=5;
triangle_h=5;
wall=1.6;

id=4;
od=6;

module button() {
  rotate([0,90,0]) {
    difference() {
      linear_extrude(height=button_h) {
        polygon(round_corners(square([button_w,button_l],anchor=BACK),radius=[button_r,button_r,0,0]));
      }
      translate([0,-piptik_o,-bsl]) cylinder(d=clearance_d,h=clearance_h);
    }
  translate([0,-piptik_o,-piptik_h]) cylinder(d=piptik_d,h=clearance_h+piptik_h);
  }
}

module hook() {
  linear_extrude(height=button_w,center=true) translate([button_h,0]) rotate(-hook_a) {
    translate([-wall,-button_h/2])square([wall,hook_l+button_h/2]);
    translate([0,hook_l]) polygon([[0,0],[-triangle_h,0],[0,triangle_l]]);
  }
  for(tr=[[0,0,-button_w/2],[0,0,button_w/2-wall]])translate(tr) linear_extrude(height=wall) {
    polygon([[-offset,0],[button_h,0],[(hook_l)*sin(hook_a)-wall*cos(hook_a)+button_h,(hook_l)*cos(hook_a)+wall*sin(hook_a)]]);
  }
}

difference() {
  union() {
    button();
    cylinder(d=od,h=button_w,center=true);
    hook();
  }
  cylinder(d=id,h=button_w+bsl,center=true);
}