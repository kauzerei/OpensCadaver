//The food drier that I bought had shelves too low for filament spools
//This is a higher tube that fits two spools
//My printer is too small for such a print, so that's a quarter of a cylinder
//Print four and weld together with 3d-pen
$fa=1;
$fs=0.1;
id=236;
echo(id);
od=234;
echo (od);
wall=2;
h1=80;
h2=15;
bissl=0.01;
module ring() {
  transition=id-od+4*wall;
  difference() {
    cylinder(h=h1,d=od);
    translate([0,0,-bissl])cylinder(h=h1+2*bissl,d=od-2*wall);
  }
  translate([0,0,h1])  difference() {
    cylinder(h=transition/2,d1=od,d2=id+2*wall);
    translate([0,0,-bissl])cylinder(h=transition/2+2*bissl,d1=od-2*wall,d2=id);
  }
  translate([0,0,h1+transition/2])  difference() {
    cylinder(h=h2,d=id+2*wall);
    translate([0,0,-bissl])cylinder(h=h2+2*bissl,d=id);
  }
}
intersection() {
  ring();
  difference() {
  cutter(h=h1+h2+(id-od+4*wall)/2,w=5,max_s=500);
  rotate([0,0,-90])cutter(h=h1+h2+(id-od+4*wall)/2,w=5,max_s=500);
  }
}
module cutter(h,w,max_s) {
  for (i=[0:4*w:h]) {
    hull() {
      translate([-w/2,-max_s/2,i])cube([max_s+w/2,max_s,w]);
      translate([w/2,-max_s/2,i+w]) cube([max_s-w/2,max_s,w]);
    }    hull() {
      translate([-w/2,-max_s/2,i+4*w])cube([max_s+w/2,max_s,w]);
      translate([w/2,-max_s/2,i+3*w]) cube([max_s-w/2,max_s,w]);
    }
    translate([w/2,-max_s/2,i+2*w]) cube([max_s-w/2,max_s,w]);
  }
}
