include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;

id=4.6; //inner diameter of joint ring
od=9.5; //outer diameter of joint ring
ring_w=4.3; //width of the inner ring
dist=10.5; //distance between ring centers
width=8.5; //height in printed orientation, complete width of both halves of the joint
depth=12; //size of joint front to back without a knee cap
//oc=2.3; //off-centerness of joint, defines outer joint size

shift=[0.90,0.70]; //how shifted center of outer joint circles are relative to axles 
r1=2.0; //rounding outer radius
r2=0.25; //rounding inner radius
gap=0.1; //gap between all rings' surfaces from inner joint surfaces

knee_r1=10;
knee_r2=5.5;
knee_w=11.2;
knee_front=14.5;
wedge_pos=[1.4,1.3];
wedge_r=2.5;

module outer_shell() {
  hull() {
    translate([-dist/2,0]+shift) circle(d=depth);
    mirror([1,0])translate([-dist/2,0]+shift) circle(d=depth);
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

module kneecap() {
  intersection() {
    up(width/2) back(knee_front-depth/2+shift[1]) torus(or=knee_r1,r_min=knee_r2,anchor=BACK);
    wedge=arc(n=2,r=50,angle=[60,135],wedge=true);
    up(width/2-knee_w/2)linear_extrude(height=knee_w/2) translate(wedge_pos) polygon(round_corners(wedge,r=wedge_r));
  }
}

module knee_half() {
  wall=(width-ring_w)/2-gap;
  convex_offset_extrude(bottom=os_circle(r=r1), height=wall,steps=8) outer_shell();
  up(wall) linear_extrude(ring_w/2+gap) offset(r=r2) offset(r=-r2) inner_shape();
  difference() {
    kneecap();
    up(wall) left(dist/2) cylinder(d=od+2*gap,h=knee_w);
    up(wall) right(dist/2) cylinder(d=od+2*gap,h=knee_w);
  }
}

knee_half();

fwd(15) mirror([0,1,0]) knee_half();