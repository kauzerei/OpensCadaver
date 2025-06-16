// Tools to remove/install bottom bracket on my bike.
// Didn't know how this this is called so didn't find on the thingiverse/printables
// so designed my own. Found out later, but upload it anyway.
// Outer nut unscrewer is designed to use with 24mm wrench

part="outer_nut";//[outer_nut,bearing_holder]

$fs=1/2;
$fa=1/2;
bissl=1/100;

module gear(ir,or,n,da=0,dh=0.5) {
  arr=[for (i=[0:1:n-1]) let(a=i*360/n) each [ir*[sin(a),cos(a)],
                                            or*[sin(a+360*da/n),cos(a+360*da/n)],
                                            or*[sin(a+dh*360/n),cos(a+dh*360/n)],
                                            ir*[sin(a+dh*360/n+da*360/n),cos(a+dh*360/n+da*360/n)]]];

  polygon(arr);
}

if (part=="bearing_holder") {
  ir=30/2;
  or=32/2;
  n=20;
  da=0.05;
  dh=0.45;
  id=20;
  crown_thickness=4;
  handle_thickness=4;
  handle_rounding=10;
  handle_width=100;

  difference(){
    union() {
      hull() {
        translate([0,(handle_width-handle_rounding)/2,0]) cylinder(d=handle_rounding,h=handle_thickness);
        translate([0,-(handle_width-handle_rounding)/2,0]) cylinder(d=handle_rounding,h=handle_thickness);
        cylinder(d=2*or,h=handle_thickness);
      }
      translate([0,0,handle_thickness])linear_extrude(height=crown_thickness,convexity=3) gear(ir=ir,or=or,n=n,da=da,dh=dh);
    }
    translate([0,0,-bissl])cylinder(h=handle_thickness+crown_thickness+2*bissl,d=id);
  }
}

if (part=="outer_nut") {
  dent_depth=1.5;
  dent_width=4;
  od=44.5;
  coupling_depth=4;
  hole=20;
  wall=5;
  wrench=24;
  wrench_width=8;
  wrench_d=wrench*2/sqrt(3);
  transition_height=(od-hole)/2;
  difference() {
    union() {
      cylinder(d=od+2*wall,h=coupling_depth+wall);
      hull() {
        translate([0,0,coupling_depth+wall]) cylinder(d=od+2*wall,h=bissl);
        translate([0,0,coupling_depth+wall+(od+2*wall-wrench)/2]) cylinder($fn=6,d=wrench_d,h=bissl);
      }
      translate([0,0,coupling_depth+wall+(od+2*wall-wrench)/2]) cylinder($fn=6,d=wrench_d,h=wrench_width);
    }
    translate([0,0,-bissl])cylinder(d=od,h=coupling_depth+wall+bissl);
    translate([0,0,coupling_depth+wall-bissl]) cylinder(d1=od,d2=hole, h=transition_height+2*bissl);
    translate([0,0,0]) cylinder(d=hole,h=100); //too lazy to calculate
  }
  for (a=[0:60:300]) rotate([0,0,a]) translate([-dent_depth-od/2,-dent_width/2,0]) cube([dent_depth*2,dent_width,coupling_depth]);
}