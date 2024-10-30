// to fix HDMI cable to the arms of the stabilizer in several places
// allowing the motion of the joints, but not allowing tangling
wall=3;
screw=4;
width=12;
height=23;
depth=10;
cable=4;
radius=1.5;
bissl=1/100;
$fa=1/1;
$fs=1/2;
module single() {
  difference() {
    cuber([width+2*wall,height+4*wall+cable+screw,depth],r=radius);
    translate([wall,wall,-bissl])cube([width,height,depth+2*bissl]);
    translate([wall+width/2,2*wall+height+cable+wall+screw/2,-bissl])cylinder(h=depth+2*bissl,d=cable);
    translate([-bissl,2*wall+height+cable/2,depth/2])rotate([0,90,0])cylinder(h=width+2*wall+2*bissl,d=cable);
    translate([width/2+wall-cable/4,height+wall-bissl,-bissl])cube([cable/2,3*wall+cable+screw+2*bissl,depth+2*bissl]);
  }
}
single();
module cuber(v,r) {
  minkowski() {
    sphere (r=r);
    translate([r,r,r])cube([v[0]-2*r,v[1]-2*r,v[2]-2*r]);
  }
}