// Hook for the toy car
$fn=64;
thickness=3; //height of print
width=3; //  
bend_radius=6;
min_angle=-90; //how strong bend of the hook is
ring_diameter=3; //inner hole
linear_extrude(thickness) {
  for (angle=[min_angle:1:149])
    hull() {
      rotate([0,0,angle])translate([bend_radius,0,0])circle(d=width);
      rotate([0,0,angle+1])translate([bend_radius,0,0])circle(d=width);
    }
    translate([-bend_radius*sqrt(3),bend_radius,0])for (angle=[-90:1:-31]) hull() {
      rotate([0,0,angle])translate([bend_radius,0,0])circle(d=width);
      rotate([0,0,angle+1])translate([bend_radius,0,0])circle(d=width);
    }
  translate([-bend_radius*sqrt(3)-width/2-ring_diameter/2,0,0]) difference() {
    circle(r=ring_diameter/2+width);
    circle(r=ring_diameter/2);
    }
  }
