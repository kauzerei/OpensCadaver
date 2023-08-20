w=37;
d=18;
h=32;
t=2;
g=10;
difference() {
cube([w+2*t,d+2*t,h+t+g]);
translate([t,t,t])cube([w,d,h+g]);
translate([0,0,t])cube([w+t,d+t,h]);
}