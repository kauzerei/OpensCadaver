$fn=16*1;
bsl=1/100;

wall=2;
d=5;
h=40;
funnel=20;
/*
fun_pos=[6,13,3];
vent_pos=[0,-12,3];
module ring() {
  scale(22/16) rotate([0,0,0]) translate([-10,-10,-7]) import("../import/Prusa ring Two.STL");
}
*/
fun_pos=[6,13,3];
vent_pos=[0,-12,3];
module ring() {
  scale(16/16) rotate([0,0,0]) translate([0,0,0]) import("../import/cyber ring embossed.stl");
}
ring();

module vent(hole=false) {
  difference() {
    if(!hole) cylinder(d=d+2*wall,h=h);
    translate([0,0,-bsl])cylinder(d=d,h=h+2*bsl);
  }
}
module funnel(hole=false) {
  difference() {
    if (!hole) union() {
      if(!hole) cylinder(d=d+2*wall,h=h);
      translate([0,0,h-funnel]) cylinder(d1=d+2*wall,d2=d+2*wall+2*funnel,h=funnel);
    }
    union() {
      translate([0,0,-bsl])cylinder(d=d,h=h+2*bsl);
      translate([0,0,h-funnel]) cylinder(d1=d,d2=d+2*funnel,h=funnel+2*bsl);
    }
  }
}

*difference() {
  union() {
    minkowski() {
      hull() ring();
      sphere(r=wall);
    }
    hull() ring();
    translate(fun_pos) funnel(false);
    translate(vent_pos) vent(false);
  }
  translate(fun_pos) funnel(true);
  translate(vent_pos) vent(true);
  ring();
}
/*
rings from internet
https://www.printables.com/model/46119-open-gear-ring-everyone-is-a-maker-
https://www.printables.com/model/588392-the-well-from-the-ring-miniature
https://www.printables.com/model/143965-cyber-ring/files
https://www.printables.com/model/132512-prusa-ring
owl:
https://www.printables.com/model/59519-smile-owl-fill-ring-cork-filaments
https://www.printables.com/model/671891-owl-ring#preview.file.eTmxx
*/