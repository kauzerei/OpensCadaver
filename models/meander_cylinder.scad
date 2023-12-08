bd=54;
sd=52;
n=128;
h=8;
for (a=[0:360/n:360]) {
  rotate([0,0,a])translate([-sd*tan(90/n)/2,0,0])cube([sd*tan(90/n),sd/2,h]);
  rotate([0,0,a+180/n])translate([-sd*tan(90/n)/2,0,0])cube([sd*tan(90/n),bd/2,h]);
}