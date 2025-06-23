// Hook for the toy car
// no idea why it crashes on saving stl when run from command line
// therefore moved to drafts, otherwise fstl stops viewing on corrupted stl
$fs=1/1;
$fa=1/1;
thickness=3; //height of print
width=3;
bend_radius=6;
min_angle=-90; //how strong bend of the hook is
ring_diameter=3; //inner hole
step=5; //kinda like fa

module shape() {
  for (angle=[150-step:-step:min_angle]) hull() {
    rotate(angle) translate([bend_radius,0])circle(d=width);
    rotate(angle-step) translate([bend_radius,0])circle(d=width);
  }
  translate([-bend_radius*sqrt(3),bend_radius,0]) 
  for (angle=[-30:-step:-90+step]) hull() {
    rotate([0,0,angle])translate([bend_radius,0,0])circle(d=width);
    rotate([0,0,angle-step])translate([bend_radius,0,0])circle(d=width);
  }
  translate([-bend_radius*sqrt(3)-width/2-ring_diameter/2,0,0])
  difference() {
    circle(r=ring_diameter/2+width);
    circle(r=ring_diameter/2);
  }
}
linear_extrude(thickness) shape();
//shape();