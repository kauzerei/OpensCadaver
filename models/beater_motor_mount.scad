$fa=1/1;
$fs=1/2;
bissl=1/100;
shaft=2;
wall=2;
stick=10;
width=stick+2*wall;
compression=1;
screw=4;

difference() {
  hull() {
    cube([width,width,width/2-compression/2]);
    translate([stick/2,-3*wall-screw,0]) cube([2*wall,3*wall+screw,width/2-compression/2]);
  }
  translate([-bissl,width/2,width/2])rotate([0,90,0])cylinder(d=10,h=width+2*bissl);
  translate([width/2,-screw/2,-bissl])cylinder(d=screw,h=width/2-compression/2+2*bissl);
  translate([width/2,-screw-wall-shaft/2,-bissl])cylinder(d=shaft,h=width/2-compression/2+2*bissl);
}