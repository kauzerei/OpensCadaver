$fs=1/2;
$fa=1/2;
bissl=1/100;
od=20;
id=6;
h=12;
wall=1.6;
difference() {
  union() {
    cylinder(h=wall,d=od);
    cylinder(h=h,d=id+2*wall);
    translate([0,0,h-wall]) cylinder(h=wall,d=od);
  }
  translate([0,0,-bissl]) cylinder(d=id,h=h+2*bissl);
}