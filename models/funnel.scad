//Funnel to fill sand toys with sand
$fn=128;
d1=50;
h1=30;
d2=6;
h2=20;
d3=4;
wall=0.8;
difference() {
  union() {
    cylinder(d1=d1+2*wall,d2=d2+2*wall,h=h1);
    translate([0,0,h1])cylinder(d1=d2+2*wall,d2=d3+2*wall,h=h2);
  }
    translate([0,0,-1/100])cylinder(d1=d1,d2=d2,h=h1+2/100);
    translate([0,0,h1])cylinder(d1=d2,d2=d3,h=h2+1/100);  
}