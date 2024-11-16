$fa=1/1;
$fs=1/2;
inner_square=[50,45];
outer_square=[160,101.5];
lip=1.6;
hor_wall=2;
vert_wall=3;
led_width=12.0;
film_space=1.6;
led_space=3;
led_dist=2.9;
even=false;
perpendicular=true;
d=2;
mount_height=100;
part="NOSTL_all";//[frame_outer,frame_spacer,frame_inner,led_holder,phone_holder,ceil_mount,NOSTL_all]
if (part=="frame_outer") frame(outer_square,lip,hor_wall,vert_wall,film_space);
module frame(square,lip,hor_wall,vert_wall,thickness,d) {
  linear_extrude(height=hor_wall) difference() {
    square([square[0]+2*vert_wall,square[1]+2*vert_wall],center=true);
    square([square[0]-2*lip,square[1]-2*lip],center=true);
    for (hole=[for (i=[0.5,-0.5]) for (j=[0.5,-0.5])  [square[0]*i,square[1]*j]]) translate(hole) circle(d=d);
  }
    linear_extrude(height=thickness+hor_wall) difference() {
    square([square[0]+2*vert_wall,square[1]+2*vert_wall],center=true);
    square(square,center=true);
    for (hole=[for (i=[0.5,-0.5]) for (j=[0.5,-0.5])  [square[0]*i,square[1]*j]]) translate(hole) circle(d=d);
  }
}

module led_holder(outer_square,inner_square,vert_wall,lip,led_width,led_dist,d) {
  difference() {
    cube([outer_square[0]+2*vert_wall,outer_square[1]+2*vert_wall,hor_wall+lip],center=true);
    cube([inner_square[0]-2*lip,inner_square[1]-2*lip,hor_wall+lip+1],center=true);
  start=even?led_width/2+led_dist/2:0;
  orientation=perpendicular?90:0;
  rotate([0,0,orientation]) for (d=[start:led_width+led_dist:outer_square[orientation?1:0]/2-led_width/2]) for (m=[[0,0,0],[1,0,0]]) mirror(m)
   translate([d,0,hor_wall/2-lip/2]) rotate([90,0,0]) linear_extrude(height=max(outer_square)+2*vert_wall+1,center=true)
    polygon([[-led_width/2,0],[led_width/2,0],[0,led_width/2]]);
    for (hole=[for (i=[0.5,-0.5]) for (j=[0.5,-0.5])  [inner_square[0]*i,inner_square[1]*j]]) translate(hole)
     cylinder(d=d,h=hor_wall+lip+1,center=true);
    for (hole=[for (i=[0.5,-0.5]) for (j=[0.5,-0.5])  [outer_square[0]*i,outer_square[1]*j]]) translate(hole)
     cylinder(d=d,h=hor_wall+lip+1,center=true);
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

if (part=="phone_holder") phone_holder();
if (part=="ceil_mount") ceil_mount(outer_square,mount_height,vert_wall,d,10);
if (part=="led_holder") led_holder(outer_square,inner_square,vert_wall,lip,led_width,led_dist,d);
if (part=="NOSTL_all") {
  frame(outer_square,lip,hor_wall,vert_wall,film_space,d);
  translate([0,0,hor_wall+film_space+1]) frame(outer_square,lip,hor_wall,vert_wall,led_space,d);
  translate([0,0,hor_wall+film_space+1+2*hor_wall+2*led_space]) mirror([0,0,1]) led_holder(outer_square,inner_square,vert_wall,lip,led_width,led_dist,d);
  translate([0,0,hor_wall+film_space+1+2*hor_wall+2*led_space+2*hor_wall+2*film_space]) mirror([0,0,1]) frame(inner_square,lip,hor_wall,vert_wall,film_space,d);
  translate([0,0,hor_wall+film_space+1+2*hor_wall+2*led_space+2*hor_wall+2*film_space+1]) phone_holder();
  translate([outer_square[0]/2,0,hor_wall+film_space+1+2*hor_wall+2*led_space+hor_wall+film_space+1+mount_height])rotate([-90,0,90]) ceil_mount(outer_square,mount_height,vert_wall,d,10);
  translate([-outer_square[0]/2,0,hor_wall+film_space+1+2*hor_wall+2*led_space+hor_wall+film_space+1+mount_height])rotate([-90,0,90]) ceil_mount(outer_square,mount_height,vert_wall,d,10);
}