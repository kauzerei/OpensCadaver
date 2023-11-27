$fa=1/1;
$fs=0.5/1;
d_tube=16;
wall=3;
mount_depth=wall;
d_bolt=4;
d_nut=8;
bolt_offset=30;
mount_offset=100;
mount_width=12;
bissl=1/100;
difference() {
  hull() {
    translate([d_tube/2+wall,0,0])cylinder(h=mount_width, d=d_tube+2*wall,center=true);
    translate([-mount_offset+wall+d_tube/2,0,0]) rotate([0,0,0]) cylinder(h=mount_width, d=d_tube+2*wall,center=true);
  }
  translate([d_tube/2+wall,0,0])cylinder(h=mount_width+bissl, d=d_tube,center=true);
  translate([-d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
  translate([-d_tube/2,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  translate([-mount_offset+wall+d_tube/2,0,0]) rosette_mount_holes(depth=mount_width,center=true);
  
  hull() {
    translate([-mount_offset+wall+d_tube+d_tube/2,0,0]) cylinder(h=mount_width+bissl,d=d_tube-2*wall,center=true);
    translate([d_tube/2+wall,0,0]) cylinder(h=mount_width+bissl,d=d_tube-2*wall,center=true);
  }
}
module rosette_mount_holes(depth=10,d_circle=12, d_center=4, d_around=2, n_holes=4,bissl=1/100,center=false) {
  translate([0,0,center?0:-bissl])cylinder(h=depth+2*bissl,d=d_center,center=center);
  *translate([0,0,-bissl]) cylinder(h=h_nut+2*bissl, d=d_nut,$fn=6);
  for (i=[0:360/n_holes:360]) rotate([0,0,i])translate([d_circle/2,0,center?0:-bissl]) 
    cylinder(h=depth+2*bissl, d=d_around,center=center);
}