$fa=1/1;
$fs=1/2;
bissl=1/100;

use <cross_polarized_light.scad>

part="NOSTL_all";//[frame_outer,frame_spacer,led_holder,NOSTL_all]

/* [general shape and size] */
outer_square=[101,51];
led_space=3;
d=4;

/* [walls, protrusions] */
hor_wall=2;
inner_offset=2;
outer_offset=1;
lip_width=4;

/* [holding led strip] */
led_width=10.5;
led_dist=1.6;
led_thickness=1;
led_hold=1.5;
even=true;
perpendicular=true;

if (part=="frame_outer") frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=hor_wall,d=d,true,false);
if (part=="frame_spacer") frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=led_space,d=d,true,true);
if (part=="led_holder") led_holder(l_film_x=outer_square[0],l_film_y=outer_square[1],s_film_x=0,s_film_y=0,thickness=hor_wall+led_thickness+led_hold,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,led_width=led_width,led_thickness=led_thickness,led_dist=led_dist,led_hold=led_hold,d=d,perpendicular=perpendicular,even=even);

//think of a better way of writing such assemblies more elegantly
if (part=="NOSTL_all") {
  frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=hor_wall,d=d,true,false); translate([0,0,hor_wall+1]) {
  frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=led_space,d=d,true,true); translate([0,0,led_space+1]) {
  translate([0,0,hor_wall+led_thickness+led_hold]) mirror([0,0,1]) led_holder(l_film_x=outer_square[0],l_film_y=outer_square[1],s_film_x=0,s_film_y=0,thickness=hor_wall+led_thickness+led_hold,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,led_width=led_width,led_thickness=led_thickness,led_dist=led_dist,led_hold=led_hold,d=d,perpendicular=perpendicular,even=even); translate([0,0,hor_wall+led_thickness+led_hold+1]);
}
}
}