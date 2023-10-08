
/* Project: camera stab
weight holder
*/
$fn=64;
*difference() {
  union() {
  cylinder(d=28,h=20);
  cylinder(d=40,h=8);
  }
  cylinder(d=4,h=21);
  cylinder(d=8,h=4);
}
h1=8;
h2=1;
h3=8;
id=7;
od=29;
hd=40;
hex=12.5;
hexh=4;
handle=54;
difference() {
  union() {
  cylinder(d=od,h=h1+h2+h3);
  cylinder(d=hd,h=h1+h2);
  handle(d=handle,h=h3,n=6);
  }
  cylinder(d=id,h=h1+h2+h3+0.01);
  translate([0,0,-0.01])cylinder($fn=6,d=hex,h=hexh);
}
module handle(d,n,h) {
  difference() {
    union() {
      cylinder(d=d,h=h,$fn=2*n);
      for (i=[0:360/n:360]) {
        rotate([0,0,i])translate([d/2,0,0])cylinder(d=d*sin(90/n),h=h);
      }
    }
    for (i=[0:360/n:360]) {
      rotate([0,0,i+180/n])translate([d/2,0,-0.01])cylinder(d=d*sin(90/n),h=h+0.02);
    }
  }
}