w=37;
d=18;
h=32;
t=2;
g=10;
difference() {
cube([w+2*t,d+2*t,h],center=true);
cube([w,d,h+0.02],center=true);
}