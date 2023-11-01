//a half of holder of L-profiles at 45 degrees
//Project: diy slider rail for diy dolly
$fa=1;
$fs=0.5;
part="rail_holder"; //[rail_holder,tripod_mount]
wall=3;
rod=9;
rod_distance=50;
thickness=3;
side=30;
screw=4;
bissl=0.01;
module rail_holder() {
  difference() {
    linear_extrude(2*rod,convexity=5) {
      rotate(45) {
        square([side,wall]);
        translate([side,-wall-thickness])square([wall,2*wall+thickness]);
        translate([side-wall,-wall-thickness])square([wall,wall]);
      }
      polygon([[0,0],[-2*rod,0],[-2*rod,rod],[rod,rod]]);
    }
    translate([-rod,-bissl,rod])rotate([-90,0,0])cylinder(d=rod,h=rod+2*bissl);
  }
}
module tripod_mount() {
  thick=rod/2+wall;
  size=rod+2*wall+rod_distance;
  difference() {
    translate([-size/2,-size/2,0])cube([size,size,thick]);
    translate([0,-rod_distance/2,thick])rotate([0,90,0])cylinder(d=rod,h=size+bissl,center=true);
    translate([0,rod_distance/2,thick])rotate([0,90,0])cylinder(d=rod,h=size+bissl,center=true);
    translate([0,0,thick-3])cylinder(d=14,h=3+bissl,$fn=6);
    translate([0,0,-bissl])cylinder(d=8,h=thick);
    translate([0,0,-bissl])for(t=[[wall+screw/2-size/2,rod+2*wall+screw/2-size/2],[wall+screw/2-size/2,size/2-rod-2*wall-screw/2],[size/2-wall-screw/2,rod+2*wall+screw/2-size/2],[size/2-wall-screw/2,size/2-rod-2*wall-screw/2]])
      translate(t)cylinder(d=screw,h=thick+2*bissl);
  }
}
if (part=="rail_holder") rail_holder();
if (part=="tripod_mount") tripod_mount();