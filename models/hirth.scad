diameter=24;
//depth=10;
n=7;
$fa=1;
$fs=1;
  w=90;
//h=2;
//a=180/n;
//r=diameter/2;
//x=sqrt(2*((r*sin(a))^2)/(1-2*(sin(a))^2));
//ang=atan(x/(sqrt(2)*r));
/*
module hirth(n=60,d=24,h=2) {
  difference() {
    cylinder(d=diameter,h=h+x/sqrt(2),$fn=n);
    translate([0,0,h])for (a=[0:360/n:360-360/n]) rotate ([0,0,a]) rotate([90+ang/2,0,0])rotate([0,0,45])cube([2*x,2*x,r+x]);
  }
}
*/
/*
difference() {
  hirth(n=n,d=diameter,h=h);
  translate([0,0,h/2])cylinder(d=16,h=h);
  for(a=[0:90:270]) rotate([0,0,a])translate([5,0,-0.01])cylinder(d=3,h=h);
  translate([0,0,-0.01])cylinder(d=4,h=h);
  }
  */
module tooth() {
//  n=12;
//  a=360/n;
d=diameter;
  r=diameter/2; //first approx of cylinder radius
//  h1=r*cos(a/2);
//  b1=2*r*sin(a/2);
//  h2=b1/2/tan(w/2);
//  r*sin(a/2)/h2=tan(w/2);
//  h2=r*sin(a/2)/tan(w/2);
//  h2=r*sin(180/n)/tan(w/2);
//  b=asin(h2/h1);
//b=asin(r*cos(180/n)/(r*sin(180/n)/tan(w/2)));
//b=asin(tan(180/n)/tan(w/2));
//echo(tan(180/n));
//echo(tan(w/2));
//echo(b);
//p1=[d*cos(b/2),0,d*sin(b/2)];
//p2=[d*cos(b/2)*cos(180/n),sin(180/n),-d*sin(b/2)];
//p3=[d*cos(b/2)*cos(180/n),-sin(180/n),-d*sin(b/2)];
l=r*sin(90/n);
//tan(w/2)=l/h
h=l/tan(w/2);
x=r*cos(90/n);
b=asin(h/x);
  polyhedron(points=[[0,0,0],
                     [d*cos(b),0,d*sin(b)],
                     [d*cos(b)*cos(180/n),d*cos(b)*sin(180/n),-d*sin(b)],
                     [d*cos(b)*cos(180/n),-d*cos(b)*sin(180/n),-d*sin(b)],
                     [0,0,-d*sin(b)]],
                     faces=[[0,2,1],[0,1,3],[1,2,3],[0,4,2],[0,3,4],[4,3,2]]);
}
//[d*cos(b/2),0,d*sin(b/2)] rotated b/2 up
//[d*cos(b/2),0,-d*sin(b/2)] rotated b/2 down
//d*cos(b/2)*cos(180/n),d*cos(b/2)*sin(180/n)
translate([0,0,0.001])for(i=[0:360/n:360])rotate([0,0,i])tooth();