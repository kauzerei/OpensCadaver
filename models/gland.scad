$fs=1/1;
$fa=1/1;

difference() {
  union() {
    cylinder(d=8,h=2);
    translate([0,0,2]) cylinder(d=6,h=8);
  }
  for(i=[0:1:10]) translate([0,0,i]) for (m=[0,1]) mirror([0,0,m]) cylinder(d1=4,d2=3,h=0.5);
  translate([-10,0,0])cube([20,20,20]);
}