// Arm to mount something offset and perpendicualr to a tube a tube
// Probably should become a part of rig-htsized repo
$fa=1/1;
$fs=0.5/1;
d_tube=15;
d_mount=16;
wall=3;
mount_depth=wall;
h_ring=d_mount+2*wall;
d_bolt=3;
d_nut=8;
mount_hole=8;
bolt_offset=20;
mount_offset=100;
mount_width=10;
bissl=0.01;
difference() {
  hull() {
    translate([d_tube/2+wall,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
    translate([-mount_offset+wall+d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
  }
  translate([d_tube/2+wall,0,0])cylinder(h=h_ring+bissl, d=d_tube,center=true);
  translate([-d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
  translate([-d_tube/2,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  translate([-mount_offset+wall+d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=mount_hole,center=true);
  translate([-mount_offset+wall+d_tube/2,-d_tube/2-wall+mount_depth,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_mount);
  hull() {
    translate([min(d_tube/2+wall-mount_offset/2,-d_tube-wall),0,0]) cylinder(h=h_ring+bissl,d=d_tube-2*wall,center=true);
    translate([d_tube/2+wall,0,0]) cylinder(h=h_ring+bissl,d=d_tube-2*wall,center=true);
  }
  hull() {
    d=2*(d_tube+2*wall-mount_width);
    translate([min(d_tube/2+wall-mount_offset/2,-d_tube-wall)-d_tube/2-wall-d/2,mount_width,0]) cylinder(h=h_ring+bissl,d=d,center=true);
    translate([-mount_offset+wall+d_tube/2-d,mount_width,0]) cylinder(h=h_ring+bissl,d=d,center=true);
  
  }
}