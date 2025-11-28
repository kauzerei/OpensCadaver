/* thingiverse/printables description
Thingiverse/Printables description:
Tweezers/ tongs/ forceps for grabbing thin wide flat things, lying on a flat surface.
Made it for DIY PCB production: developing photoresist, etching; stripping.
Could be also use to grab glass plates for analog photography or microscopy.
Written in OpenSCAD + BOSL2, so fully customizable: width, thickness on both ends, 
the geometry of joint (influences springiness) and of the teeth (width and length)

There is a million 3d-models of tweezers here, but none of them have
the shape and ability to open wide, that I need.
There are smaller ones that look promising, but would be too thick if I scale them.
Lots of them had fancy rounded profile, which is not nice to print,
and also bad for grabbing big flat things, so I had to design my own.
Print as is without supports.

My github repo for all of my models may contain a newer version of this model,
if I decide to update somethinga and forget to reupload:
https://github.com/kauzerei/OpensCadaver/blob/main/models/tweezers.scad
*/

include <../import/BOSL2/std.scad>
$fn=64;
thickness=3.2;
thinness=1.6;
length=180;
angle=30;
width=8;
arc_width=10;
arc_thickness=16;
joint=3;
teeth_width=3.2;
teeth_length=1.6;
p1=arc(width=arc_width,thickness=arc_thickness);
p2=[length*[sin(angle/2),cos(angle/2)],[0,0]];
p3=[length*[sin(angle/2),-cos(angle/2)],[0,0]];
p=simplify_path(path_join(paths=[p3,p1,p2],joint=3),maxerr=0.0001);
thicknesses=[thinness,for (i=[1:1:len(p)-2]) thinness+(thickness-thinness)*(0.5+cos(i*360/(len(p)-2))/2),thinness];
teeth=move(v=[-teeth_width,thinness/2],p=scale([teeth_width,teeth_length],[[0,0],[0,1],[0.5,0],[1,1],[1,0]])) ;
linear_extrude(height=width) {
  path_copies(p,n=2,closed=false,sp=teeth_width) polygon(teeth);
  stroke(p,width=thicknesses,endcaps="butt");
}