$fa=1/1;
$fs=1/2;
d_tube=22;
h_ring=15;
d_bolt=4;
d_nut=8;
wall=3;
bissl=0.01;
offset=0;
nut=false;
coupling=false;
bcd=10;
n_screws=4;
d_circle=2;
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
