$fs=1/1;
$fa=1/1;
bsl=1/100;

length=85;
width=60;
thickness=8;
offsets=[0,18,36];
r=2;

module cs() {
  offset(r=-r) offset(r=2*r) offset(r=-r) {
    difference() {
      union() {
        circle(d=width);
        translate([-width/2,0])square([width,length-width/2]);
      }
      circle(d=width-2*thickness);
        translate([-width/2+thickness,0])square([width-2*thickness,length-width/2]);
    }
    for (y=offsets) translate([-width/2,length-width/2-thickness-y]) square([width,thickness]);
  }
}

module drafted_extrude(height,angle,fn=32) {
  intersection_for(a=[360/fn:360/fn:360]) linear_extrude(height=height,v=[cos(a),sin(a),tan(angle)]) children();
}

linear_extrude(thickness,center=true) cs();
for (m=[0,1]) mirror([0,0,m])translate([0,0,thickness/2]) drafted_extrude(r,45) cs();