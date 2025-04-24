$fa=1/1;
$fs=1/2;
bissl=1/100;

part="NOSTL_all";//[frame_outer,frame_spacer,led_holder,NOSTL_all]

/* [general shape and size] */
outer_square=[101,51];
led_space=3;
d=4;

/* [walls, protrusions] */
hor_wall=3;
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

module contact_line(film_x,film_y,lip_width) {
  roof(method="voronoi", convexity=3) difference() {
    offset(r=lip_width) square([film_x,film_y],center=true);
    square([film_x,film_y],center=true);
  }
}

module frame(film_x,film_y,inner_offset,outer_offset,lip_width,thickness,d,upper_feature,lower_feature) {
  difference() {
    union() {
      linear_extrude(height=thickness,convexity=2) difference() {
        offset(r=lip_width+outer_offset) square([film_x,film_y],center=true);
        square([film_x-2*inner_offset,film_y-2*inner_offset],center=true);
      }   
    if(upper_feature)translate([0,0,thickness])contact_line(film_x=film_x,film_y=film_y,lip_width=lip_width);
    }
    if(lower_feature) translate([0,0,-bissl])contact_line(film_x=film_x,film_y=film_y,lip_width=lip_width);
    for (i=[-0.5,0.5]) for (j=[-0.5,0.5]) 
      translate([i*(film_x+lip_width+outer_offset-inner_offset),j*(film_y+lip_width+outer_offset-inner_offset),-bissl])
        cylinder(d=d,h=thickness+lip_width/2+2*bissl);
  }
}

module led_holder(l_film_x,l_film_y,s_film_x,s_film_y,thickness,lip_width,outer_offset,inner_offset,led_width,led_thickness,led_dist,led_hold,d,perpendicular,even) {
  start=even?led_width/2+led_dist/2:0;
  orientation=perpendicular?90:0;
  
  module ledgrid() {
   rotate(orientation) for (shift=[start:led_width+led_dist:(perpendicular?l_film_y:l_film_x)/2-led_width/2]) for (m=[[0,0],[1,0]]) mirror(m)
   translate([shift,0]) square([led_width,(perpendicular?l_film_x:l_film_y)+lip_width],center=true);
  }
   
  difference() {
    linear_extrude(height=thickness,convexity=2) difference() {
      offset(r=lip_width+outer_offset) square([l_film_x,l_film_y],center=true);
      if(s_film_x!=0 && s_film_y!=0) square([s_film_x-2*inner_offset,s_film_y-2*inner_offset],center=true);      
    }
    translate([0,0,thickness+bissl]) mirror([0,0,1]) contact_line(film_x=l_film_x,film_y=l_film_y,lip_width=lip_width);
    translate([0,0,-bissl]) contact_line(film_x=s_film_x,film_y=s_film_y,lip_width=lip_width);
    translate([0,0,thickness-led_thickness-led_hold]) linear_extrude(height=led_thickness,convexity=2) ledgrid();
    translate([0,0,thickness-led_hold]) roof(convexity=4) ledgrid();  
     for (f1=[[0,0,0],[0,1,0]]) for (f2=[[0,0,0],[1,0,0]]) mirror(f1) mirror(f2) {
      translate([(l_film_x+lip_width+outer_offset-inner_offset)/2,(l_film_y+lip_width+outer_offset-inner_offset)/2,-bissl])
        cylinder(d=d,h=thickness+lip_width/2+2*bissl);
      if(s_film_x!=0 && s_film_y!=0) translate([(s_film_x+lip_width+outer_offset-inner_offset)/2,(s_film_y+lip_width+outer_offset-inner_offset)/2,-bissl])
        cylinder(d=d,h=thickness+lip_width/2+2*bissl);
    }    
  }      
}

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