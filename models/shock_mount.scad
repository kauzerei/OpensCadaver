$fa=1/1;
$fs=1/2;
bissl=1/100;
id=60;
h=40;
wall=1.6;
n=7;
d=4;
difference(){
cylinder($fn=n,h=h,d=id+2*wall,center=true);
cylinder($fn=n,h=h+bissl,d=id,center=true);
for (m=[[0,0,0],[0,0,1]]) mirror(m)
for (a=[-90:360/n:360]) rotate([0,0,a])translate([0,id,-h/2+d/2-bissl])cube([d,2*id,d],center=true);
rotate([0,-90,0])cylinder(d=10,h=2*id);
}