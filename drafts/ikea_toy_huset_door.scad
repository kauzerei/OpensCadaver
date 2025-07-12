difference() {
  cube([44,147,2.5]);
  translate([44-12.5/2-4,147/2,-0.1])cylinder(d=12.5,h=2.7);
}
translate([0,-2,0]) cube([2.5,147+2*2,2.5]);