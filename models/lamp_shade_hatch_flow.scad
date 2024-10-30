//Attempt at making an interestingly shaped pamp shade. Never used
use <hatch_flow.scad>
unit_height=19.999;
nvert=4;
od=80;
id=70;
nhor=16;
hvert=nvert*unit_height;
ring(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=1,od=od,id=id);
cylinder(h=hvert,d=id,$fn=nhor*4);
translate([0,0,hvert]) cylinder (h=20,d1=id,d2=40,$fn=nhor*4);
translate([0,0,hvert+20]) cylinder (h=5,d=40,$fn=nhor*4);