$fa=1/1;
$fs=1/2;
d_tube=16;
h_ring=15;
d_bolt=4;
d_nut=8;
h_nut=4;
wall=3;
bissl=0.01;
offset=1;
nut=true;
coupling=false;
bcd=10;
n_screws=4;
d_circle=2;
center_to_center=60;
connect_thickness=8;
module single_clamp() {
  difference() {
    union() {
      hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
    }
    translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  if (coupling) translate([-d_bolt/2-offset,d_tube/2+wall,0]) rotate([90,0,0]) for (i=[180/n_screws:360/n_screws:360]) rotate([0,0,i])translate([bcd/2,0,-0.01]) cylinder(h=2*wall+0.02,d=d_circle);
    translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
  }
}
module double_clamp() {
  difference() {
    union() {
      hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
        translate([0,center_to_center,0]) hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
      translate([d_tube+wall-connect_thickness,0,-h_ring/2])cube([connect_thickness,center_to_center,h_ring]);
      
    }
    translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
    translate([d_tube/2,center_to_center,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset,-d_tube/2+center_to_center,0]) rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
  if (nut) translate([-d_bolt/2-offset,d_tube/2+wall+bissl,0]) rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
    translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-offset,center_to_center,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall+center_to_center,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
    for (i=[20,30,40]) {
      translate([-connect_thickness+d_tube+wall-bissl,i,0])rotate([90,0,90])cylinder(d=d_nut, h=h_nut,$fn=6);
      translate([-connect_thickness+d_tube+wall-bissl,i,0])rotate([90,0,90])cylinder(d=d_bolt, connect_thickness+2*bissl);
    }
  }
}
module double_clamp_wall() {
  connect_thickness=5;
  h_ring=17;
  difference() {
    union() {
      hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
        translate([0,center_to_center,0]) hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
      translate([d_tube/2,0,-h_ring/2])hull() {
      for (t=[[-85+31+5,10,0],[-85+31+5,50,0],[0,10,0],[0,50,0]]) translate(t) cylinder (d=10,h=connect_thickness);
      }
    }
translate([d_tube/2,0,-h_ring/2-bissl]) for (t=[[-85+31+5,10,0],[-85+31+5,30,0],[-85+31+5,50,0]]) translate(t) cylinder (d=d_bolt,h=connect_thickness+2*bissl);
      
    translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
    translate([d_tube/2,center_to_center,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset,-d_tube/2+center_to_center,0]) rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
  if (nut) translate([-d_bolt/2-offset,d_tube/2+wall+bissl,0]) rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
    translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-offset,center_to_center,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall+center_to_center,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
  }
}
single_clamp();
//double_clamp_wall();