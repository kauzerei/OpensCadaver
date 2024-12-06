$fa=1/1;
$fs=1/2;
bissl=1/100;

part="NOSTL_all";//[frame_outer,frame_spacer,led_holder,frame_inner,phone_holder,ceil_mount,NOSTL_all]

/* [general shape and size] */
inner_square=[48,48];
outer_square=[160,101.5];
led_space=5;
d=4;
phone_distance=10;
mount_height=100;

/* [walls, protrusions] */
hor_wall=3;
vert_wall=3;
inner_offset=2;
outer_offset=1;
lip_width=4;

/* [holding led strip] */
led_width=11.5;
led_dist=1.3;
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

module profile(wall,elevation,phone_h,chamfer,fillet) {
  difference() {
    polygon([[0,0],[2*wall,0],[2*wall,elevation+phone_h/2-chamfer],[2*wall-chamfer,elevation+phone_h/2],
             [wall+chamfer,elevation+phone_h/2],[wall,elevation+phone_h/2-chamfer],[wall,elevation+chamfer],[wall-chamfer,elevation],
             [chamfer,elevation],[0,elevation-chamfer]]);
    translate([wall-fillet,elevation+fillet])circle(r=fillet);
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

module phone_holder(thickness,lip_width,outer_offset,film_x,film_y,inner_offset) {
  difference() {
    union() {
      linear_extrude(height=thickness,convexity=2) difference() {
        offset(r=lip_width+outer_offset) square([film_x,film_y],center=true);
        square([film_x-2*inner_offset,film_y-2*inner_offset],center=true);
      }   
      translate([-16,-55,0])phone_frame(width=70,height=148,thickness=8,larger_r=10,smaller_r=vert_wall/3,wall=vert_wall,elevation=hor_wall);
    }
    for (i=[-0.5,0.5]) for (j=[-0.5,0.5]) 
      translate([i*(film_x+lip_width+outer_offset-inner_offset),j*(film_y+lip_width+outer_offset-inner_offset),-bissl]) {
        cylinder(d=d,h=thickness+2*bissl);
        translate([0,0,thickness+2*bissl]) cylinder(d=2*d,h=100);
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
    offset=outer_square[1]+lip_width+outer_offset-inner_offset;
    for (tr=[
      [-offset/2,height-vert_wall/2,0],
      [offset/2,height-vert_wall/2,0],
      [-offset/3,vert_wall/2,0],
      [offset/3,vert_wall/2,0]
    ]) translate(tr) rotate([90,0,0]) cylinder(d=d,h=thickness*2,center=true);
  }
}
if (part=="frame_outer") frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=hor_wall,d=d,true,false);
if (part=="frame_spacer") frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=led_space,d=d,true,true);
if (part=="led_holder") led_holder(l_film_x=outer_square[0],l_film_y=outer_square[1],s_film_x=inner_square[0],s_film_y=inner_square[1],thickness=hor_wall+led_thickness+led_hold,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,led_width=led_width,led_thickness=led_thickness,led_dist=led_dist,led_hold=led_hold,d=d);
if (part=="frame_inner") frame(film_x=inner_square[0],film_y=inner_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=phone_distance,d=d,true,false);
if (part=="phone_holder") phone_holder(thickness=hor_wall,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,film_x=inner_square[0],film_y=inner_square[1]);
if (part=="ceil_mount") ceil_mount(outer_square,mount_height,vert_wall,d,10);

//think of a better way of writing such assemblies more elegantly
if (part=="NOSTL_all") {
  frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=hor_wall,d=d,true,false); translate([0,0,hor_wall+1]) {
  frame(film_x=outer_square[0],film_y=outer_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=led_space,d=d,true,true); translate([0,0,led_space+1]) {
  translate([0,0,hor_wall+led_thickness+led_hold]) mirror([0,0,1]) led_holder(l_film_x=outer_square[0],l_film_y=outer_square[1],s_film_x=inner_square[0],s_film_y=inner_square[1],thickness=hor_wall+led_thickness+led_hold,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,led_width=led_width,led_thickness=led_thickness,led_dist=led_dist,led_hold=led_hold,d=d); translate([0,0,hor_wall+led_thickness+led_hold+1]) {
  translate([0,0,phone_distance]) mirror([0,0,1]) frame(film_x=inner_square[0],film_y=inner_square[1],inner_offset=inner_offset,outer_offset=outer_offset,lip_width=lip_width,thickness=phone_distance,d=d,true,false); translate([0,0,phone_distance+1]) {
  phone_holder(thickness=hor_wall,lip_width=lip_width,outer_offset=outer_offset,inner_offset=inner_offset,film_x=inner_square[0],film_y=inner_square[1]);
}
  translate([outer_square[0]/2,0,mount_height])rotate([-90,0,90]) ceil_mount(outer_square,mount_height,vert_wall,d,10);
  translate([-outer_square[0]/2,0,mount_height])rotate([-90,0,90]) ceil_mount(outer_square,mount_height,vert_wall,d,10);
}
}
}
}