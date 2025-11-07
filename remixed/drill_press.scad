$fs=1/2;
$fa=1/2;
difference() {
  intersection() {
    sphere(d=18);
    translate([0,0,3])cylinder(d=18,h=18,center=true);
  }
  translate([0,0,-6])cylinder(d=11.8,h=5,$fn=6);
  translate([0,0,8])cylinder(d=6.2,h=18,center=true);
}