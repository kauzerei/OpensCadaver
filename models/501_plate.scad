//lower straight part
l_height=2.5;
l_width=49;
//higher straight part
h_height=2.5;
h_width=42;
//overall dimensions
length=80;
height=11;
cut=4.5;
thickness=3;
taper_length=6;
taper_depth=1;
//stoppers
spring_stop_length=25;
spring_stop_begin=5;
spring_stop_end=9;
front_stop_length=25;
front_stop_begin=6;
front_stop_end=14;
nholes=7;
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
  for (i=[-10,0,10]) for (j=[-10*(nholes-1)/2:10:10*(nholes-1)/2]) translate([j+length/2,i+l_width/2,0]) {
    cylinder(h=height+3*bissl,d=4);
    cylinder(h=height-thickness,d=8);
    }
}
module cutout() {
  polygon([[length-thickness,l_width-front_stop_begin],[length-front_stop_length+thickness,l_width-front_stop_begin],[length-front_stop_length+thickness,l_width-front_stop_end],[length-front_stop_length,l_width-front_stop_end],[length-front_stop_length,l_width-front_stop_begin],[-bissl,l_width-front_stop_begin],[-bissl,spring_stop_begin],[spring_stop_length,spring_stop_end],[spring_stop_length,spring_stop_begin],[length+bissl,spring_stop_begin],[length+bissl,spring_stop_end],[length-thickness,spring_stop_end]]);
}
rotate([180,0,0])difference() {
  positive();
 translate([0,0,-bissl]) negative();
}
       