$fa=1/1;
$fs=0.5/1;
d_tube=22;
h_ring=15;
d_bolt=4;
d_nut=8;
wall=3;
bissl=0.01;
difference() {
  hull() {
    translate([d_tube/2+wall,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
    translate([-h_ring/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
  }
  translate([d_tube/2+wall,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  translate([-h_ring/2,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  translate([-h_ring/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
  translate([-h_ring-bissl,-d_tube/2+wall,-h_ring/2-bissl])cube([h_ring+wall+d_tube/2,d_tube-2*wall,h_ring+2*bissl]);
}