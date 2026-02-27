include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;

id=4.6; //inner diameter of joint ring
od=9.5; //outer diameter of joint ring
ring_w=4.3; //width of the inner ring
dist=10.5; //distance between ring centers
width=8.5; //height in printed orientation, complete width of both halves of the joint
oc=2.3; //off-centerness of joint, defines outer joint size
r1=1.5; //rounding outer radius
r2=0.25; //rounding inner radius
gap=0.2; //gap between all rings' surfaces from inner joint surfaces

module outer_shell() {
  hull() {
    translate([-dist/2+oc/2,oc/2]) circle(d=od+oc);
    translate([dist/2-oc/2,oc/2]) circle(d=od+oc);
  }
}

module inner_shape() {
  difference() {
    outer_shell();
    translate([-dist/2,0]) circle(d=od+2*gap);
    translate([dist/2,0]) circle(d=od+2*gap);
  }
    translate([-dist/2,0]) circle(d=id-2*gap);
    translate([dist/2,0]) circle(d=id-2*gap);
}

module knee_half() {
  wall=(width-ring_w)/2-gap;
  convex_offset_extrude(bottom=os_circle(r=r1), height=wall,steps=8) outer_shell();
  up(wall) linear_extrude(ring_w/2+gap) offset(r=r2) offset(r=-r2) inner_shape();
}

knee_half();
//path1=arc(n=64,d=od,angle=[-80,160]);

//polygon(path1);

/*
module mid() {
  difference() {
    hull() {
      translate([-5.5,0,0]) circle(d=10.5);
      translate([5.5,0,0]) circle(d=10.5);
    }
  translate([-5.5,0,0]) difference() {circle(d=9.5); circle(d=4.5);}
  translate([5.5,0,0]) difference() {circle(d=9.5); circle(d=4.5);}
  }  
}

mid();
*/