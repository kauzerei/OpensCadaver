$fa=1/4;
$fs=1/4;
module profile() {
  difference() {
    union() {
      intersection() {
        translate([-10,0])square([20,22]);
        circle(r=22);
      }
      for(a=[-8:2:8]) rotate(a*atan(1/22)) translate([0,22]) circle(d=1);
    }
    for(a=[-7:2:7]) rotate(a*atan(1/22)) translate([0,22]) circle(d=1);

  }
}
module inner_profile() {
  intersection() {
    translate([-6.5,0])square([13,19]);
    translate([0,8])circle(r=11);
  }
}
difference() {
  linear_extrude(height=7,center=true)profile();
  linear_extrude(height=3,center=true)inner_profile();
  }
  