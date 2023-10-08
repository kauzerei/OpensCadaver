
/* Project: camera stab
1/4 inch jam nut that fixes the screwed-on sled in arbitrary orientation 
*/
$fn=64;
h=5.5;
wall=2;
id=8;
hex=13;
handle=36;
n=6;
difference() {
  handle(d=handle,h=h+wall,n=n);
  cylinder(d=id,h=h+wall+0.01);
  translate([0,0,wall])cylinder($fn=6,d=hex,h=h+0.01);
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