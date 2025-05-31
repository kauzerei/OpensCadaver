/* thingiverse/printables description
Pry tool for Audi A1 side mirror
A prying tool designed to remove the mirror from Audi A1 Gen 1 (8x).
Probably suits similar jobs where you need to pull something out,
having limited space to grip, like a mirror of some other VAG car :D.
Many other pry bars published here would probably also work,
this one makes it easier to pull with significant force thanks to the ring.
*/
width= 10;
thinness=1.6;
mirror=4;
thickness=5;
ring=25;
length=60;
handle_length=50;
handle_width=width;
$fn=90;
linear_extrude(width) {
  p1=[for (a=[0:1:89]) mirror*[cos(a),sin(a)]];
  p2=[for (a=[270:-1:91]) [0,mirror+thinness/2]+0.5*thinness*[cos(a),sin(a)]];
  p3=[for (a=[90:-1:0]) (mirror+thinness)*[cos(a),sin(a)]];
  polygon([each p1, each p2, each p3]);
  translate([mirror+thinness-thickness,-length])square([thickness,length]);
  translate([mirror+thinness-thickness/2,-length-ring/2-thickness/2]) difference() {
    circle(d=ring+2*thickness);
    circle(d=ring);
  }
}