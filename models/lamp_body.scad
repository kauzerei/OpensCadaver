$fa=1/1;
$fs=1/2;
bissl=1/100;

polarizer_x=100;
polarizer_y=50;
inner_offset=3;
outer_offset=1;
lip_width   =4;
hor_wall    =4;
d           =4;

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
        offset(r=lip_width+outer_offset)square([film_x,film_y],center=true);
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
  frame(film_x      =polarizer_x,
        film_y      =polarizer_y,
        inner_offset=inner_offset,
        outer_offset=outer_offset,
        lip_width   =lip_width,
        thickness   =hor_wall,
        d           =d,
        true,true);