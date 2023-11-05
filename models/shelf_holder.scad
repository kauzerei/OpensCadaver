//Shelf holder for light table
//Project: backlight table, ended up not using
$fa=1;
$fs=0.5;
difference() {
  union() {
    translate([-6.5,-5.5,0])cube([18.5,11,0.6]);
    translate([-4,-5.5,0])cube([16,11,2]);
    translate([-4,-5.5,0])cube([2,11,10]);
    intersection() {
      cylinder(h=10,d=11);
      translate([-4,-5.5,0])cube([16,11,10]);
    }
    hull() {
      translate([-4,-1,0]) cube([16,2,2]);
      translate([4.5,0,0])cylinder(h=10,d=2);
    }
  }
cylinder(h=9,d=5);
}