$fa=1/1;
$fs=0.5/1;
d_tube=16;
d_mount=16;
wall=3;
mount_depth=wall;
d_bolt=3;
d_nut=8;
mount_hole=6;
bolt_offset=20;
mount_offset=100;
mount_width=10;
bissl=0.01;
difference() {
  hull() {
    translate([d_tube/2+wall,0,0])cylinder(h=mount_width, d=d_tube+2*wall,center=true);
    translate([-mount_offset+wall+d_tube/2,0,0]) rotate([0,0,0]) cylinder(h=mount_width, d=d_tube+2*wall,center=true);
  }
  translate([d_tube/2+wall,0,0])cylinder(h=mount_width+bissl, d=d_tube,center=true);
  translate([-d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
  translate([-d_tube/2,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  translate([-mount_offset+wall+d_tube/2,0,0]) rotate([0,0,0]) cylinder(h=d_tube+2*wall+bissl, d=mount_hole,center=true);
  translate([-mount_offset+wall+d_tube/2,0,0]) rotate([0,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_mount);
  hull() {
    translate([-mount_offset+wall+d_tube+d_mount/2,0,0]) cylinder(h=mount_width+bissl,d=d_tube-2*wall,center=true);
    translate([d_tube/2+wall,0,0]) cylinder(h=mount_width+bissl,d=d_tube-2*wall,center=true);
  }
}