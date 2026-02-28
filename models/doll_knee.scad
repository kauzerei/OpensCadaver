include <../import/BOSL2/std.scad>
$fs=1/4;
$fa=1/4;
bsl=1/100;

part="ring";//[knee_plate,knee_half,ring]

id=4.6; //inner diameter of joint ring
od=9.5; //outer diameter of joint ring
ring_w=4.3; //width of the inner ring
dist=10.5; //distance between ring centers
width=8.5; //height in printed orientation, complete width of both halves of the joint
depth=12; //size of joint front to back without a knee cap
ring_offset=7; //distance from ring to block
conn_d=4; //diameter of connecting part between ring and block
rect=[3.6,7,7]; //mounting block of ring
rr=0.7; //rounding of ring part

shift=[0.90,0.70]; //how shifted center of outer joint circles are relative to axles 
r1=1.0; //rounding outer radius
r2=0.25; //rounding inner radius
gap_h=0.1; //horizontal gap between ring surface from inner joint surface
gap_v=0.2;//vertical gap between ring surface from inner joint surface

knee_r1=10;
knee_r2=5.5;
knee_w=11.2;
knee_front=14.5;
wedge_pos=[1.0,2.1];
wedge_r1=2.25; //bigger radius at bending point
wedge_r2=1; //rounding top anb bottom of kneecap on the front

module outer_shell() {
  hull() {
    translate([-dist/2,0]+shift) circle(d=depth);
    mirror([1,0])translate([-dist/2,0]+shift) circle(d=depth);
  }
}

module inner_shape() {
  difference() {
    outer_shell();
    translate([-dist/2,0]) circle(d=od+2*gap_h);
    translate([dist/2,0]) circle(d=od+2*gap_h);
  }
    translate([-dist/2,0]) circle(d=id-2*gap_h);
    translate([dist/2,0]) circle(d=id-2*gap_h);
}

module kneecap() {
  module shape() {
    wedge=round_corners(arc(n=3,r=2*knee_r1,angle=[60,135],wedge=true),r=wedge_r1);
    //wedge=arc(n=3,r=2*knee_r1,angle=[60,135],wedge=true);
    intersection() {
      back(knee_front-depth/2+shift[1]) circle(r=knee_r1,anchor=BACK);
      translate(wedge_pos) polygon(wedge);
    }
  }
  intersection() {
    up(width/2) back(knee_front-depth/2+shift[1]) torus(or=knee_r1,r_min=knee_r2,anchor=BACK);
    up(width/2-knee_w/2)linear_extrude(height=knee_w/2) offset(r=wedge_r2)offset(r=-wedge_r2)shape();
  }
}

module knee_half() {
  wall=(width-ring_w)/2-gap_v;
  //convex_offset_extrude(bottom=os_circle(r=r1), height=wall,steps=8) outer_shell();
  arc1=arc(r=r1,n=8,angle=[180,120]);
  arc2=arc(r=5,n=8,angle=[120,90]);
  prof=right(1,path_join([arc1,arc2]));
  convex_offset_extrude(bottom=os_profile(prof), height=wall,steps=8) outer_shell();
  up(wall) linear_extrude(ring_w/2+gap_v) offset(r=r2) offset(r=-r2) inner_shape();
  difference() {
    kneecap();
    up(wall) left(dist/2) cylinder(d=od+2*gap_h,h=knee_w);
    up(wall) right(dist/2) cylinder(d=od+2*gap_h,h=knee_w);
  }
}

module ring() yrot(90){
  yrot(-90)linear_extrude(ring_w,center=true) difference() {
    circle(d=od);
    circle(d=id);
  }
  yrot(-90)right(od/2+ring_offset)cube(rect,anchor=LEFT);
  difference() {
    join_prism(circle(d=conn_d),base="cylinder",base_r=od/2,fillet=rr,aux="plane",aux_T=up(od/2+ring_offset));
    right(ring_w/2) cube([rr,od,od+rr],anchor=LEFT);
    left(ring_w/2) cube([rr,od,od+rr],anchor=RIGHT);
  }
}

module ring_skookum() {
  fillet=rr*0.7;
  module crossection() {
    offset(r=-rr) offset (r=rr){
      difference() {
        circle(d=od);
        circle(d=id);
      }
      right(id/2) rect([ring_offset+(od-id)/2,conn_d],anchor=LEFT);
      right(od/2+ring_offset)rect([rect[0],rect[1]],anchor=LEFT);
    }
  }
  for (mirror=[[0,0,0],[0,0,1]]) mirror(mirror) {
    linear_extrude(ring_w/2-fillet, convexity=4) crossection();
    up(ring_w/2-fillet) intersection() {
      roof(method="voronoi", convexity=4) crossection();
      linear_extrude(fillet, convexity=4) crossection();
    }
  }
}

if (part=="knee_half") knee_half();
if (part=="knee_plate") yrot(180){
  fwd(15) mirror([0,1,0]) knee_half();
  knee_half();
}
if (part=="ring") ring();