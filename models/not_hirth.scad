diameter=24;
depth=10;
n=60;
$fa=1;
$fs=1;
h=2;
//polyhedron(points=[[0,0,0],[-depth,diameter/2,-depth/2],[0,diameter/2,depth/2],[depth,diameter/2,-depth/2],[0,0,-depth]],faces=[[0,1,2],[2,1,3],[0,3,1],[0,2,3]]);
/*difference() {
  union() {
    for (a=[0:360/n:360-360/n]) rotate ([0,0,a]) polyhedron(points=[[0,0,0],[-depth,diameter/2,-depth/2],[0,diameter/2,depth/2],[depth,diameter/2,-depth/2],[0,0,-depth/2]],faces=[[0,1,2],[2,1,3],[0,2,3],[0,4,1],[0,3,4],[4,3,1]]);
    translate([0,0,-depth/2-h])cylinder(d=diameter,h=h,$fn=n);
  }
  translate([0,0,-depth/2-h])cylinder(d=4,h=h+diameter);
  for(a=[0:90:270]) rotate([0,0,a])translate([5,0,-depth/2-h])cylinder(d=3,h=h+diameter);
  translate([0,0,-depth/2-h/2])cylinder(d=16,h=h+diameter);
  
}*/
a=180/n;
r=diameter/2;
x=sqrt(2*((r*sin(a))^2)/(1-2*(sin(a))^2));
ang=atan(x/(sqrt(2)*r));
module hirth(n=60,d=24,h=2) {
  difference() {
    cylinder(d=diameter,h=h+x/sqrt(2),$fn=n);
    translate([0,0,h])for (a=[0:360/n:360-360/n]) rotate ([0,0,a]) rotate([90+ang/2,0,0])rotate([0,0,45])cube([2*x,2*x,r+x]);
  }
}
/*translate([0,0,-depth/2-h])cylinder(d=4,h=h+diameter);
    for(a=[0:90:270]) rotate([0,0,a])translate([5,0,-depth/2-h])cylinder(d=3,h=h+diameter);
    translate([0,0,-depth/2-h/2])cylinder(d=16,h=h+diameter);*/
difference() {
  hirth(n=n,d=diameter,h=h);
  translate([0,0,h/2])cylinder(d=16,h=h);
  for(a=[0:90:270]) rotate([0,0,a])translate([5,0,-0.01])cylinder(d=3,h=h);
  translate([0,0,-0.01])cylinder(d=4,h=h);
  }