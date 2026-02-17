include <../import/BOSL2/std.scad>
$fa=1/1;
$fs=1/1;
bsl=1/100;

or=54;
ir=27;
depth=20;
rb=2;
rf=2;
wall=0.8;
hole=18;

edge_dist=7;
edge_angle=120;
edge_len=12;
//reflector_shape=round_corners(rect([depth,or-ir],spin=90,anchor=TOP+LEFT),r=[rf,rb,rb,rf]);
chamfered=round_corners(rect([depth,or-ir],spin=90,anchor=TOP+LEFT),method="chamfer",cut=[rf,0,0,rf]);
reflector_shape=round_corners(chamfered,joint=[0,rf,rb,rb,rf,0]);
reflector_profile=[each reflector_shape, each reverse(offset(reflector_shape,-wall))];

module reflector(solid=false) {
  rotate_extrude(angle=360,convexity=4) translate([ir,0]) {
    if(solid) hull() polygon(reflector_profile);
    if(!solid) polygon(reflector_profile);
  }
}

module with_flash_geometry() {
  intersection() {
    reflector(solid=true);
    rotate([90,0,0]) linear_extrude(height=or,convexity=4) translate([0,edge_dist]) {
      a=edge_angle/2;
      stroke((edge_len*[[sin(-a),cos(-a)],[0,0],[sin(a),cos(a)]]),width=wall);
    }
  }
  difference() {
    reflector();
    translate([0,-(or+ir)/2,-bsl]) cylinder(h=depth+2*bsl,d=hole);
  }
}

with_flash_geometry();

/*
reflector_path=circle(r=ir);
path_sweep2d(shape=reflector_profile,path=reflector_path,closed=true);
*/

//polygon(reflector_profile);
//stroke(reflector_profile);