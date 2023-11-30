//This is tripod cheese plate
//Made for Zhiyun Crane 2, but it looks like regular Manfrotto 501 Plate
//I decided to make everything customizable, because lots of plates on Thingiverse have different dimensions.
//I've printed one of them and it was too loose.
//Maybe my plate differs from Manfrotto, maybe creators of the models build printer tolerances into model.
//This one can be scaled as flexibly as possible.
//Just measure your original part and enter values into customizer
//If the part is too wide or too narrow, correct the values
/* [Dimensions of lower rectangular part] */
l_height=2.5;
l_width=49;
/* [Dimensions of higher rectangular part] */
h_height=2.5;
h_width=42;
/* [Plate dimensions] */
length=80;
height=11;
//height of cutouts for stoppers
cut=4.5;
//thin walls, for examples walls that hold screws
thickness=3;
//Vertical taper for easier sliding the plate into tripod
taper_length=6;
taper_depth=1;
/* [Configuration of stoppers] */
//how far to push the plate before it clicks
spring_stop_length=25;
//when pushed all the way to the front, this part of the plate stays in tripod
front_stop_length=25;
//positions of stoppers on the tripod
spring_stop_begin=5;
spring_stop_end=9;
front_stop_begin=6;
front_stop_end=14;
/* [Cheeseplate raster] */
nholes_across=1;
nholes_along=1;
d_bolt=7;
d_head=20;
$fa=1/1;
$fs=1/2;
bissl=1/100;
module positive() {
  hull() {
    translate([taper_length,0,0])cube([length-taper_length,l_width,l_height]);
    translate([taper_length,(l_width-h_width)/2,l_height])cube([length-taper_length,h_width,height-h_height-l_height]);
    translate([0,taper_depth,0])cube([length-taper_length,l_width-2*taper_depth,l_height]);
    translate([0,(l_width-h_width)/2+taper_depth,l_height])cube([length-taper_length,h_width-2*taper_depth,height-h_height-l_height]);
  }
  hull() {
    translate([taper_length,(l_width-h_width)/2,height-h_height])cube([length-taper_length,h_width,h_height+bissl]);
    translate([0,(l_width-h_width)/2+taper_depth,height-h_height-bissl])cube([length-taper_length,h_width-2*taper_depth,h_height+bissl]);
  }
}
module negative() {
  linear_extrude(height=cut) cutout();
  for (i=[-10*(nholes_along-1)/2,0,10*(nholes_along-1)/2])
    for (j=[-10*(nholes_across-1)/2:10:10*(nholes_across-1)/2])
      translate([j+length/2,i+l_width/2,0]) {
        cylinder(h=height+3*bissl,d=d_bolt);
        cylinder(h=height-thickness,d=d_head);
      }
}
module cutout() {
  polygon([[length-thickness,l_width-front_stop_begin],[length-front_stop_length+thickness,l_width-front_stop_begin],[length-front_stop_length+thickness,l_width-front_stop_end],[length-front_stop_length,l_width-front_stop_end],[length-front_stop_length,l_width-front_stop_begin],[-bissl,l_width-front_stop_begin],[-bissl,spring_stop_begin],[spring_stop_length,spring_stop_end],[spring_stop_length,spring_stop_begin],[length+bissl,spring_stop_begin],[length+bissl,spring_stop_end],[length-thickness,spring_stop_end]]);
}
rotate([180,0,0])difference() {
  positive();
 translate([0,0,-bissl]) negative();
}
