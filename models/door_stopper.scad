$fs=1/2;
$fa=1/2;
bsl=1/100;
od=30;
id=10;
gap=1;
l=50;
h=15;
hole=4;
cap=3;
d=l-od;
h3=(h-2*gap)/3;
part="NOSTL_all";//[flap,holder,knob,NOSTL_all]
module holder() difference() {
  union() {
    linear_extrude(height=h3) circle(d=od);
    linear_extrude(height=h+gap) circle(d=id);
    linear_extrude(height=2*h3+gap) intersection() {
      circle(d=od);
      polygon([[0,0],[-od,0],[-od/sqrt(2),-od/sqrt(2)]]);
    }
  }
  translate([0,0,-bsl])cylinder(h=h+gap+2*bsl,d=hole);
}
module flap() {
  linear_extrude(height=h3) difference() {
    hull() {
      circle(d=od);
      translate([0,d,0])circle(d=od);
    }
    circle(d=id+2*gap);
  }
  linear_extrude(height=h) difference() {
    hull() {
      circle(d=od);
      translate([0,d,0])circle(d=od);
    }
    circle(d=od+2*gap);
    circle(d=id+2*gap);
  }
  linear_extrude(height=2*h3+gap) intersection() {
    difference() {
      circle(d=od+2*gap);
      circle(d=id+2*gap);
    }
    rotate(-90-22.5)polygon([[0,0],[-od,0],[-od/sqrt(2),-od/sqrt(2)]]);
  }
}
module knob() {
  linear_extrude(height=cap) difference() {
    circle(d=od);
    circle(d=hole);
  }
}
if (part=="holder")  holder();
if (part=="flap") flap();
if (part=="knob") knob();
if (part=="NOSTL_all") {
  holder();
  translate([0,0,h])mirror([0,0,1]) flap();
  translate([0,0,h+2*gap]) knob();
}
