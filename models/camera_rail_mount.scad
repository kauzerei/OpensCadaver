/*
difference() {
  translate([-45,-20,-70])cube([90,40,70]);
  translate([-30,0,-54])rotate([90,0,0])cylinder(d=16,h=50,center=true);
  translate([30,0,-54])rotate([90,0,0])cylinder(d=16,h=50,center=true);
  }
  */
d_nut=8;
h_nut=4;
d_bolt=4;
thickness=10;
border=2;
bissl=0.01;
$fa=1/1;
$fs=1/2;
depth=40;
module camera_plate() {
  difference() {
    cube([60,depth,thickness+border]);
    translate([30,depth/2,-bissl])cylinder(d=7,h=thickness+border+2*bissl);
    for (r=[10:20:60]) {
      translate([r,1.5*h_nut,thickness/2]) hull( ) {
        rotate([90,90,0]) cylinder(d=d_nut, h=h_nut+bissl,$fn=6);
        translate([0,0,thickness]) rotate([90,90,0]) cylinder(d=d_nut, h=h_nut+bissl,$fn=6);
      }  
      translate([r,depth-2*h_nut+1.5*h_nut,thickness/2]) hull( ) {
        rotate([90,90,0]) cylinder(d=d_nut, h=h_nut+bissl,$fn=6);
        translate([0,0,thickness]) rotate([90,90,0]) cylinder(d=d_nut, h=h_nut+bissl,$fn=6);
      }
      translate([r,2*h_nut,thickness/2]) rotate([90,0,0]) cylinder(d=d_bolt, h=2*h_nut+bissl);
      translate([r,depth+bissl,thickness/2]) rotate([90,0,0]) cylinder(d=d_bolt, h=2*h_nut+bissl);  
    }
    hull() {
      translate([0,depth/2+10,thickness+4])rotate([0,90,0])cylinder(d=8,h=60);
      translate([0,depth/2-13,thickness+1])rotate([0,90,0])cylinder(d=2,h=60);
      translate([0,depth/2-13,thickness+1+6])rotate([0,90,0])cylinder(d=2,h=60);
      translate([30,depth/2+20,thickness+31.5])rotate([90,0,0])cylinder(d=63,h=10);
    }
  }
}
camera_plate();