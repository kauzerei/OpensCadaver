part="NOSTL_all";//[frame_outer,frame_spacer,frame_inner,led_holder,phone_holder,ceil_mount,NOSTL_all]
$fa=1/1;
$fs=1/2;
bissl=1/100;

inner_square=[50,51];
outer_square=[160,101.5];
hor_wall=3;
vert_wall=3;

inner_offset=2;
outer_offset=1;
lip_width   =4;

led_width=11.5;
led_space=5;
led_dist=1.3;
led_thickness=1;
led_hold=1.5;
even=true;
perpendicular=true;
d=4;
mount_height=100;

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

module led_holder(l_film_x,l_film_y,s_film_x,s_film_y,thickness,lip_width,outer_offset,inner_offset,led_width,led_thickness,led_dist,led_hold,d) {
  start=even?led_width/2+led_dist/2:0;
  orientation=perpendicular?90:0;
  
  module ledgrid() {
   rotate(orientation) for (shift=[start:led_width+led_dist:outer_square[orientation?1:0]/2-led_width/2]) for (m=[[0,0],[1,0]]) mirror(m)
   translate([shift,0]) square([led_width,l_film_x+lip_width],center=true);
  }
   
  difference() {
    linear_extrude(height=thickness,convexity=2) difference() {
      offset(r=lip_width+outer_offset) square([l_film_x,l_film_y],center=true);
      square([s_film_x-2*inner_offset,s_film_y-2*inner_offset],center=true);      
    }
    translate([0,0,thickness+bissl]) mirror([0,0,1]) contact_line(film_x=l_film_x,film_y=l_film_y,lip_width=lip_width);
    translate([0,0,-bissl]) contact_line(film_x=s_film_x,film_y=s_film_y,lip_width=lip_width);
    translate([0,0,thickness-led_thickness-led_hold]) linear_extrude(height=led_thickness,convexity=2) ledgrid();
    translate([0,0,thickness-led_hold]) roof(convexity=4) ledgrid();  
    for (f1=[[0,0,0],[0,1,0]]) for (f2=[[0,0,0],[1,0,0]]) mirror(f1) mirror(f2) {
      translate([(l_film_x+lip_width+outer_offset-inner_offset)/2,(l_film_y+lip_width+outer_offset-inner_offset)/2,-bissl])
        cylinder(d=d,h=thickness+lip_width/2+2*bissl);
      translate([(s_film_x+lip_width+outer_offset-inner_offset)/2,(s_film_y+lip_width+outer_offset-inner_offset)/2,-bissl])
        cylinder(d=d,h=thickness+lip_width/2+2*bissl);
    }    
  }      
}

module phone_frame(width,height,thickness,larger_r,smaller_r,wall,elevation){
  difference() {
    for (i=[0,1], j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) 
    {
      translate([width/2-larger_r,height/2-larger_r])rotate_extrude(angle=90) 
      translate([larger_r-wall,0]) profile(wall,elevation,thickness,smaller_r,smaller_r);
      translate([width/2-larger_r,height/2-larger_r]) rotate([90,0,0]) linear_extrude(height=height/2-larger_r,convexity=3)
      translate([larger_r-wall,0]) profile(wall,elevation,thickness,smaller_r,smaller_r);
      translate([0,height/2-larger_r]) rotate([90,0,90]) linear_extrude(height=width/2-larger_r,convexity=3)
      translate([larger_r-wall,0]) profile(wall,elevation,thickness,smaller_r,smaller_r);
    }
  translate([0,-height/2,elevation+20]) rotate([90,0,0]) cylinder(d=40,h=wall*3,center=true);
  }
}

module phone_holder() {
  difference() {
    union() {
      difference() {
        translate([0,0,hor_wall/2]) cube([inner_square[0]+2*vert_wall,inner_square[1]+2*vert_wall,hor_wall],center=true);
        translate([0,0,hor_wall/2]) cube([inner_square[0]-2*lip,inner_square[1]-2*lip,hor_wall+1],center=true);
      }
      translate([-16,-55,0])phone_frame(width=70,height=148,thickness=8,larger_r=10,smaller_r=vert_wall/3,wall=vert_wall,elevation=2*hor_wall);
    }
    for (hole=[for (i=[0.5,-0.5]) for (j=[0.5,-0.5])  [inner_square[0]*i,inner_square[1]*j]]) translate(hole) {
      cylinder(d=d,h=hor_wall+lip+1,center=true);
      translate([0,0,hor_wall]) cylinder(d=2*d,h=100);
    }
  }
}

module ceil_mount(outer_square,height,vert_wall,d,offset) {
  width=outer_square[1]+2*offset+2*vert_wall;
  thickness=vert_wall;
  coords=[[-width/2,thickness/2],
          [width/2,thickness/2],
          [width/2,height-thickness/2],
          [-width/2,height-thickness/2],
          [-width/2,thickness/2],
          [0,height-thickness/2],
          [width/2,thickness/2]];
  difference() {
    linear_extrude(height=2*hor_wall+d,center=true,convexity=4) {
      for (i=[0:len(coords)-2]) hull() {
        translate(coords[i]) circle(d=thickness);
        translate(coords[i+1]) circle(d=thickness);
      }
    }
    for (tr=[
      [-outer_square[1]/2,height-vert_wall/2,0],
      [outer_square[1]/2,height-vert_wall/2,0],
      [-outer_square[1]/3,vert_wall/2,0],
      [outer_square[1]/3,vert_wall/2,0]
    ]) translate(tr) rotate([90,0,0]) cylinder(d=d,h=thickness*2,center=true);
  }
}
if (part=="frame_outer") frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=hor_wall,d=d,true,false);
if (part=="frame_spacer") frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=led_space,d=d,true,true);
if (part=="led_holder") led_holder(l_film_x=outer_square[0],l_film_y=outer_square[1],s_film_x=inner_square[0],s_film_y=inner_square[1],thickness=hor_wall+led_thickness+led_hold,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,led_width=led_width,led_thickness=led_thickness,led_dist=led_dist,led_hold=led_hold,d=d);
if (part=="frame_inner") frame(film_x=inner_square[0],film_y=inner_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=hor_wall,d=d,true,false);
if (part=="phone_holder") phone_holder();
if (part=="ceil_mount") ceil_mount(outer_square,mount_height,vert_wall,d,10);

if (part=="NOSTL_all") {
  frame(outer_square,lip,hor_wall,vert_wall,film_space,d);
  translate([0,0,hor_wall+film_space+1]) frame(outer_square,lip,hor_wall,vert_wall,led_space,d);
  translate([0,0,hor_wall+film_space+1+2*hor_wall+2*led_space]) mirror([0,0,1]) led_holder(outer_square,inner_square,vert_wall,lip,led_width,led_dist,d);
  translate([0,0,hor_wall+film_space+1+2*hor_wall+2*led_space+2*hor_wall+2*film_space]) mirror([0,0,1]) frame(inner_square,lip,hor_wall,vert_wall,film_space,d);
  translate([0,0,hor_wall+film_space+1+2*hor_wall+2*led_space+2*hor_wall+2*film_space+1]) phone_holder();
  translate([outer_square[0]/2,0,hor_wall+film_space+1+2*hor_wall+2*led_space+hor_wall+film_space+1+mount_height])rotate([-90,0,90]) ceil_mount(outer_square,mount_height,vert_wall,d,10);
  translate([-outer_square[0]/2,0,hor_wall+film_space+1+2*hor_wall+2*led_space+hor_wall+film_space+1+mount_height])rotate([-90,0,90]) ceil_mount(outer_square,mount_height,vert_wall,d,10);
}