/* Project: light table
To hold wooden planks 35x17, to which led lights are mounted */

w=37; //width of 35x17 plank
d=18; //depth of 35x17 plank
h=32; //height of table top, here same as width of lower plank
t=2; //wall thickness in mm
g=10; //depth on which the plank is inserted
part="upper"; // [upper,lower]
if (part=="upper")
difference() {
cube([w+2*t,d+2*t,h+t+g]);
translate([t,t,t])cube([w,d,h+g]);
translate([0,0,t])cube([w+t,d+t,h]);
}
if (part=="lower")
difference() {
cube([w+2*t,d+2*t,h],center=true);
cube([w,d,h+0.02],center=true);
}
