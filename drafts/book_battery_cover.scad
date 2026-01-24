$fs=1/2;
$fa=1/2;
difference() {
  union() {
    cube([26,28,1.6]);
    translate([10,-3,0])cube([6,3,1.6]);
    translate([13,-3,0])cylinder(d=6,h=1.6);
  }
  translate([13,-3,-0.1])cylinder(d=2,h=1.8);
}
translate([2.5,26,4])cube([4,4,1.2]);
translate([2.5,26,0])cube([4,2,4]);

translate([18.5,26,4])cube([4,4,1.2]);
translate([18.5,26,0])cube([4,2,4]);