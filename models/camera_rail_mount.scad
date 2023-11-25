bolts_offset=6;
d_nut=8;
h_nut=4;
d_bolt=4;
width=60;
thickness=8;
border=2;
bissl=0.01;
$fa=1/1;
$fs=1/2;
depth=40;
n_holes=5;
hole_distance=10;
wall=3;
module camera_plate() {
  difference() {
    cube([width,depth,thickness+border]);
    translate([width/2,depth/2,-bissl])cylinder(d=7,h=thickness+border+2*bissl);
  for (t=[-hole_distance*(n_holes-1)/2:hole_distance:hole_distance*(n_holes-1)/2])
    translate([t+width/2,0,-bissl]) {
      translate([0,bolts_offset,0])cylinder(d=d_bolt,h=thickness);
      translate([0,bolts_offset,wall])cylinder(d=d_nut,h=thickness);      
      translate([0,depth-bolts_offset,0])cylinder(d=d_bolt,h=thickness);
      translate([0,depth-bolts_offset,wall])cylinder(d=d_nut,h=thickness);
}
    hull() {
      translate([0,depth/2+10,thickness+4])rotate([0,90,0])cylinder(d=8,h=60);
      translate([0,depth/2-13,thickness+1])rotate([0,90,0])cylinder(d=2,h=60);
      translate([0,depth/2-13,thickness+1+6])rotate([0,90,0])cylinder(d=2,h=60);
      translate([30,depth/2+20,thickness+31.5])rotate([90,0,0])cylinder(d=63,h=10);
    }
  }
}
camera_plate();