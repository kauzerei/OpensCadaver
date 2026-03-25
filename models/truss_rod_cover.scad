$fs=1/2;
$fa=1/2;
bsl=1/100;

screw_pos=[[-16,10],[16,10],[0,43]];
minx=min([for (pos=screw_pos) pos[0]]);
maxx=max([for (pos=screw_pos) pos[0]]);
miny=min([for (pos=screw_pos) pos[1]]);
wall=4.5;
hole=3;
head=6;
thickness=2;
template=false;

module shape() {
/*  translate([-26,0]) square([52,2]);
  difference() {
    hull() for (pos=screw_pos){
      translate(pos) circle(d=hole+2*wall);
    }
  }*/
  difference() {
    hull() {
      offset(delta=hole/2+wall,chamfer=true) polygon(screw_pos);
      translate([minx-wall,0])square([maxx-minx+2*wall,miny]);
    }
    for (pos=screw_pos) translate(pos) circle(d=hole);
  }
  if(template) translate([-26,0]) square([52,2]);
}

difference() {
  intersection() {
    linear_extrude(h=thickness,convexity=4) shape();
    if(!template) hull() {
      roof(convexity=4) shape();
      linear_extrude(thickness) polygon([screw_pos[0],screw_pos[1],[minx,0],[maxx,0]]);
    }
  }
  for (pos=screw_pos) translate(pos) cylinder(d1=hole,d2=head,h=thickness);
}