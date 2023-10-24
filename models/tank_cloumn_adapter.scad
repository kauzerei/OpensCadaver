// Center column dev tank adapter
// Project: shooting tutorial video for oatl
$fn=64;
d1=40;
d2=20.5;
d3=12;
d4=8;
h1=3;
h2=5;
h3=10;
n=5;
wall=2;
module legs() {
  intersection() {
    union() {
      cylinder(h=h1,d=d1);
      translate([0,0,h1]) cylinder(h=h2,d=d2);
      translate([0,0,h1+h2]) cylinder(h=h3,d1=d2,d2=0);
    }
    union() {
      for (a=[0:360/n:360]) rotate([0,0,a]) translate([-wall/2,0,0]) cube([wall,d1,h1+h2+h3]);
      cylinder(d=d3+2*wall,h=h1+h2+h3);
    }
  }
}
difference() {
  legs();
  cylinder(d=d3,h=h1+h2+h3);
}
translate([0,0,-wall]) difference() {
    cylinder(h=wall,d=d1);
    cylinder(h=wall,d=d4);
  }