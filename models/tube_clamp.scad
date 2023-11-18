$fa=1/1;
$fs=0.5/1;
d_tube=22;
h_ring=15;
d_bolt=4;
d_nut=8;
wall=3;
bissl=0.01;
offset=0;
nut=false;
h_coupling=1;
d_coupling=12;
difference() {
  union() {
    hull() {
      translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
      translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
    }
    translate([-d_bolt/2-offset,d_tube/2+wall+h_coupling,0]) rotate([90,0,0]) cylinder(h=h_coupling, d=d_coupling);
  }
  translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
if (nut) translate([-d_bolt/2-offset,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+2*h_coupling+bissl, d=d_bolt,center=true);
  translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
}
