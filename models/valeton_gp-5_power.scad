include <../import/BOSL2/std.scad>

$fs=1/2;
$fa=1/2;
bsl=1/100;
wall=0.8;
width=38;
length=40;
round=6;
ear_offset=5;
ear_d=7;
hole=4;

module footprint() {
rect([length,width],rounding=[round,-round,-round,round],anchor=RIGHT);
}

module box() {
  translate([length,0,0])difference() {
    linear_extrude(height=34,scale=[1+tan(2),1-tan(2)], convexity=4) footprint();
    translate([0,0,wall]) linear_extrude(height=34,scale=[1+tan(2),1-tan(2)]) offset(r=-wall) footprint();
  }
  //mounting ears
  difference() {
    union() {
      translate([-ear_offset,width/2-ear_offset,0])cylinder(h=wall,d=ear_d);
      translate([-ear_offset,-width/2+ear_offset,0])cylinder(h=wall,d=ear_d);
      translate([-ear_offset,-width/2,0])cube([ear_offset+ear_d/2,ear_offset+ear_d/2,wall]);
      translate([-ear_offset,width/2-ear_offset-ear_d/2,0])cube([ear_offset+ear_d/2,ear_offset+ear_d/2,wall]);
    }
      translate([-ear_offset,width/2-ear_offset,-bsl])cylinder(h=wall+2*bsl,d=hole);
      translate([-ear_offset,-width/2+ear_offset,-bsl])cylinder(h=wall+2*bsl,d=hole);
    
  }
  
  }

box();