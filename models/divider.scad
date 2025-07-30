//Dividers for lidl container. It came with too few small dividers and none of the big, had to 3d-print

include <../import/BOSL2/rounding.scad>
include <../import/BOSL2/std.scad>
$fn=32;
part="big";//[big,small]
if (part=="small") {
  width=1;
  w1=66.5;
  w2=66;
  w3=64;
  w4=63.5;
  h1=17;
  h2=34;
  p=[[0,-w1/2],[0,w1/2],[h1,w2/2],[h1,w3/2],[h2,w4/2],[h2,-w4/2],[h1,-w3/2],[h1,-w2/2]];
  union() {
    rotate([0,-90,0]) linear_extrude(height=width,center=true) polygon(p);
    intersection() {
      rotate([0,-90,0]) linear_extrude(height=3*width,center=true,convexity=3) difference() {
        polygon(p);
        offset(delta=-width) polygon(p);
      }
      linear_extrude(height=34,scale=[0,1]) square([16,67],center=true);
    }
  }
}
if (part=="big") rotate([0,-90,0]){
  w1=90;
  w2=86.4;
  r=8;
  h=64;
  wall=3.5;
  slot=1.5;
  clamping=2;
  bsl=1/10;
  p=[[0,-w1/2],[0,w1/2],[h,w2/2],[h,-w2/2]];
  pout=[[p[0][0]-bsl,p[0][1]-bsl],[p[1][0]-bsl,p[1][1]+bsl],[p[2][0]+bsl,p[2][1]+bsl],[p[3][0]+bsl,p[3][1]-bsl]];
  pin=[[p[0][0]-bsl,p[0][1]-bsl],[p[1][0]-bsl,p[1][1]+bsl],[p[2][0]-slot,p[2][1]-slot],[p[3][0]-slot,p[3][1]+slot]];
  pr=round_corners(path=p,method="circle",radius=[0,0,r,r],$fn=32);
  linear_extrude(height=wall,center=true) {
      translate([clamping/2,-w1/2]) circle(d=clamping);
      translate([clamping/2,w1/2]) circle(d=clamping);
    }
  difference() {
    linear_extrude(height=wall,center=true) polygon(pr);
    linear_extrude(height=slot,center=true,convexity=3) difference() {
      polygon(round_corners(path=pout,method="circle",radius=[0,0,r,r],$fn=32));
      polygon(round_corners(path=pin,method="circle",radius=[0,0,r,r],$fn=32));
    }
   * linear_extrude(height=wall+bsl,center=true) union() {
      translate([0,-w1/2+wall]) square([10,wall]);
      translate([0,w1/2-2*wall]) square([10,wall]);
    }
  }
}