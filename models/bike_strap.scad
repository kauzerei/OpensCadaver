include <../import/BOSL2/std.scad>
min_length=50; //placement of nearest hole
max_length=500; // placement of furthest hole
width=20; //strap width
thickness=1.5;
min_diameter=100;
max_diameter=120;
distance=15;

pi=355/113;
revolutions=2*(max_length)/(pi*(max_diameter+min_diameter));
pitch=(max_diameter-min_diameter)/revolutions;
n=floor((max_length-min_length)/distance);

module oval_hole() { //it's a separate module in case you want a fancy shape here
cylinder(d=10,h=2*thickness,center=true);
}

path = helix(h=0,d1=min_diameter,d2=max_diameter,turns=revolutions,$fn=128);
path2d=[for (p=path) [p[0],p[1]]];
difference() {
  linear_extrude(h=width,center=true,convexity=3)stroke(path=path2d,endcap1="line",width=thickness);
  path_copies(path, n=n, spacing=distance, sp=min_length) oval_hole();
}