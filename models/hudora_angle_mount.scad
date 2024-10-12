$fa=1/1;
$fs=1/2;
inner_d=25;
inner_flat=22;
outer_d=32;
angle=18;
gap=2;
lip=1.6;
height=15;
difference() {
  for (m=[[0,0,0],[0,0,1]]) mirror(m) {
    cylinder(d=outer_d,h=height/2);
    translate([0,0,height/2]) cylinder(d1=outer_d,d2=outer_d+2*lip,h=lip);
    translate([0,0,height/2+lip]) cylinder(d=outer_d+2*lip,h=lip);
  }
  rotate([angle,0,0]) {
    intersection() {
      cylinder(d=inner_d,h=10*height,center=true);
      cube([inner_flat,10*height,10*height],center=true);
    }
  }
  cube([gap,10*height,10*height],center=true);
}