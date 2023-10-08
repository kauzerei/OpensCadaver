/*Project: camera stab
alternative non-adjustable plate for steadycam */
$fn=64;
db=7; //central hole diameter
ds=5; //smaller hole diameter
hb=5; //height of head of central screw
hs=4; //height of smaller nut
nb=13; //size of head of central screw
ns=9; //size of head of smaller nuts
d=36; //distance between holes
pd=48; //plate diameter
h=18; //plate height
difference() {
  cylinder(h=h,d=pd);
  translate([d/2,0,-0.01]) cylinder (d=ds,h=h+0.02);
  translate([-d/2,0,-0.01]) cylinder (d=ds,h=h+0.02);
  translate([d/2,0,-0.01]) cylinder ($fn=6,d=ns,h=hs);
  translate([-d/2,0,-0.01]) cylinder ($fn=6,d=ns,h=hs);
  translate([0,0,-0.01]) cylinder (d=db,h=h+0.02);
  translate([0,0,h-hb]) cylinder ($fn=6,d=nb,h=hb+0.01);
}