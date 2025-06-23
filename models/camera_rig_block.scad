// A solid cheeseplate block. 
// Spacer for bringing camera cage higher or something
// Probably should become a part of rig-htsized repo
nholes_across=5;
nholes_along=5;
d_hole=4;
d_nut=8;
h_nut=3;
thickness=12;
raster=10;
$fa=1/1;
$fs=1/2;
bissl=1/100;
double_sided=false;
hole_support=false;
central_hole=16;
layer_height=0.4;
module double_sided_block(nholes_across=5,nholes_along=5,d_hole=4,d_nut=8,h_nut=3,thickness=12,raster=10,hole_support=true) {
  difference() {
    cube([nholes_across*raster,nholes_along*raster,thickness]);
    translate([nholes_across*raster/2,nholes_along*raster/2,-bissl])cylinder(h=thickness+2*bissl,d=central_hole);
    for (x=[raster/2:raster:nholes_across*raster])
      for (y=[raster/2:raster:nholes_along*raster]) {
        if (pow(x-nholes_across*raster/2,2)+pow(y-nholes_along*raster/2,2)>pow(central_hole/2+d_nut/2,2) || central_hole<d_hole) {
          translate([x,y,hole_support?h_nut+0.4:-bissl])cylinder(h=thickness+2*bissl,d=d_hole);
          if (double_sided) translate([x,y,-bissl])cylinder(h=h_nut+bissl,d=d_nut,$fn=6);
          translate([x,y,thickness-h_nut])cylinder(h=h_nut+bissl,d=d_nut,$fn=6);
        }
      }
  }
  
}
double_sided_block(nholes_across=nholes_across,nholes_along=nholes_along,d_hole=d_hole,d_nut=d_nut,h_nut=h_nut,thickness=thickness,raster=raster,hole_support=hole_support);