//Arri-Rosette-type Hirth joint. It does mesh perfectly with itself unlike some other designs on Thingiverse. To the best of my knowledge it follows exactly the shape of the real deal, but I'm too poor to actually purcase an Arri product to check. 
//I use it to mount to narrow parts with cylindrical-headed screws. I'll make a standard rosette with countersunk holes some day 
//thickness of the mounting plane underneath the joint
thickness=1.5;
//vertical distance between mounting plate and lowest point of teeth, place for head of a screw
screw_head_space=1;
//diameter of lowered part
screw_side_space_diameter=16;
//diameter of mounting circle
bcd=10;
//number of screws in circle
n_screws=4;
//diameter of central hole
d_center=4;
//diameter of mounting holes
d_circle=2.5;
$fa=1/1;
$fs=1/2;
use <hirth.scad>
module arri_rosette(thickness=1.5,screw_head_space=1,screw_side_space_diameter=16,bcd=12,n_screws=4,d_center=4,d_circle=2.5) {
  difference() {
    union() {
      translate([0,0,thickness+screw_head_space]) intersection() {
        hirth(d=33,n=60,w=90);
        cylinder(d1=32,d2=32-2*hirth_height(32/cos(180/60),60,90),h=hirth_height(32/cos(180/60),60,90),$fn=60);
        }
      cylinder(h=thickness+screw_head_space,d=32,$fn=60);  
    }
    translate([0,0,thickness]) cylinder(d=screw_side_space_diameter,h=screw_head_space+hirth_height(32/cos(180/60),60,90));
    for (i=[0:360/n_screws:360-360/n_screws]) rotate([0,0,i])translate([bcd/2,0,-0.01]) cylinder(h=thickness+0.02,d=d_circle);
    translate([0,0,-0.01]) cylinder(h=thickness+0.02,d=d_center);
  }  
}
arri_rosette(thickness=thickness, screw_head_space=screw_head_space, screw_side_space_diameter=screw_side_space_diameter, bcd=bcd, n_screws=n_screws, d_center=d_center, d_circle=d_circle);