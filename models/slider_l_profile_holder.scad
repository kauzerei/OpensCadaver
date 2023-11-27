//a half of holder of L-profiles at 45 degrees
//Project: diy slider rail for diy dolly
$fa=1/1;
$fs=0.5/1;
part="rail_holder"; //[rail_holder,tripod_mount]
wall=3;
rod=9;
rod_distance=50;
thickness=3;
side=30;
screw=4;
bissl=0.01;
mount_width=30;
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
  thick=rod+2*wall;
  size=rod+2*wall+rod_distance;
  difference() {
    translate([-mount_width/2,-size/2,0])cube([mount_width,size,thick]);
    translate([0,-rod_distance/2,thick/2])rotate([0,90,0])cylinder(d=rod,h=size+bissl,center=true);
    translate([0,rod_distance/2,thick/2])rotate([0,90,0])cylinder(d=rod,h=size+bissl,center=true);
    translate([0,0,2])cylinder(d=14,h=thick,$fn=6);
    translate([0,0,-bissl])cylinder(d=8,h=thick);
  }
}
if (part=="rail_holder") rail_holder();
if (part=="tripod_mount") tripod_mount();