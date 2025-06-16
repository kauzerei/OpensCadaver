/* thingiverse/printables description
Pry tool for Audi A1 side mirror, customizable

A prying tool designed to remove the mirror from Audi A1 Gen 1 (8x).

Probably suits similar jobs where you need to pull something out,
having limited space to grip, like a mirror of some other VAG car :D.

Many other pry bars published here would probably also work,
this one makes it easier to pull with significant force thanks to the ring.

Place thin radial parts of two (or more) of those tools between
the reflective part of the mirror and the frame (see picture),
and pull them in turns in a particular way: the mechanism for adjusting
the mirror swivels, so don't allow one side of the mirror sink inside
the frame as you pull the other side. Apply the force simultaneously
to both tools, but move them towards you in turns in kind of 
gentle swinging motion.

Made in OpenSCAD, fully customizable for different jobs:
the thickness and length of radial part and other parameters
cam be changed. My github repo for all of my models may contain
a newer version of this model if I decide to update something:
https://github.com/kauzerei/OpensCadaver/blob/main/models/prying_tool_mirror_audi_a1.scad
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