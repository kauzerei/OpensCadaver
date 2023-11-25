//Yet another parametric thumb screw head
//because I did not really like any of the screws I've seen on Thingiverse
h_cp=2;
d_cp=12;
h_lobes=10;
d_bolt=5;
d_head=9;
width=22;
radius=2;
wall=2;
height=18;
bissl=1/100;
$fa=1/1;
$fs=1/2;
difference() {
  union() {
    translate([0,0,h_cp])hull() {
      cylinder(d=d_cp,h=height-h_cp);
      translate([width/2-radius,0,(height-h_cp)/2+h_lobes/2-radius]) sphere(r=radius);
      translate([width/2-radius,0,(height-h_cp)/2-h_lobes/2+radius]) sphere(r=radius);
      translate([-width/2+radius,0,(height-h_cp)/2+h_lobes/2-radius]) sphere(r=radius);
      translate([-width/2+radius,0,(height-h_cp)/2-h_lobes/2+radius]) sphere(r=radius);
    }
    cylinder(h=h_cp,d=d_cp);
  }
  translate([0,0,-bissl])cylinder(d=d_bolt,h=height);
  translate([0,0,wall])cylinder(d=d_head,h=height,$fn=6);
}