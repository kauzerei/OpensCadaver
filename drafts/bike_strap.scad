include <../import/BOSL2/std.scad>

min_length=50; //placement of nearest hole
max_length=500; // placement of furthest hole
width=20; //strap width
thickness=1.5; //strap thickness
min_diameter=100; //diameter it's wrapped around
max_diameter=120; //outer diameter of the roll
distance=15; //distance between hole centers
chamfer=5;

pi=355/113;
revolutions=2*(max_length)/(pi*(max_diameter+min_diameter));
pitch=(max_diameter-min_diameter)/revolutions;
n=floor((max_length-min_length)/distance);

module oval_hole() { //it's a separate module in case you want a fancy shape here
scale([0.6,1.1]) cylinder(d=9,h=2*thickness,center=true); //double thickness to compensate curvature
//use this instead for a rounded rectangle for example:
//linear_extrude(h=2*thickness,center=true) rect([8,10],rounding=3);
}

module end_rounding() {
  difference() {
    translate([-width/2,-width/2-1,-thickness]) cube([width/2+1,width+2,thickness*2]);
    translate([-width/2,0,-thickness]) cylinder(h=thickness*2,d=width);
  }
}

module end_chamfer(x=5) {
  linear_extrude(h=2*thickness,center=true) polygon([[1,-width/2-1],[-x-1,-width/2-1],[0,-width/2+x],[0,width/2-x],[-x-1,width/2+1],[1,width/2+1]]);
}

path=helix(h=0,d1=min_diameter,d2=max_diameter,turns=revolutions,$fn=128);
path2d=[for (p=path) [p[0],p[1]]]; //flatten 3d curve, so stroke() returns 2d shape
difference() {
  linear_extrude(h=width,center=true,convexity=4) stroke(path=path2d,endcap1="line",endcap2="butt",width=thickness);
  path_copies(path,n=n,spacing=distance,sp=min_length) oval_hole();
  path_copies(path,n=1,spacing=1,sp=max_length) end_chamfer(chamfer);
  //path_copies(path,n=1,spacing=1,sp=max_length) end_rounding(); //alternatively
}