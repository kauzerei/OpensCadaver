include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;

id=4.5;
od=9.5;
dist=10;

path1=arc(n=64,d=od,angle=[-80,160]);

polygon(path1);

/*
module mid() {
  difference() {
    hull() {
      translate([-5.5,0,0]) circle(d=10.5);
      translate([5.5,0,0]) circle(d=10.5);
    }
  translate([-5.5,0,0]) difference() {circle(d=9.5); circle(d=4.5);}
  translate([5.5,0,0]) difference() {circle(d=9.5); circle(d=4.5);}
  }  
}

mid();
*/