$fa=1/1;
$fs=1/2;
bissl=1/100;
polarizer_x=100;
polarizer_y=50;
inner_offset=3;
outer_offset=1;
lip_width=4;
hor_wall=4;
d=4;
x=polarizer_x+lip_width;
y=polarizer_y+lip_width;
module contact_line() {
  roof(method="voronoi", convexity=3) difference() {
    offset(r=lip_width) square([x-lip_width,y-lip_width],center=true);
    square([x-lip_width,y-lip_width],center=true);
  }
}
module layer(thickness,upper_feature,lower_feature) {
  difference() {
    union() {
      linear_extrude(height=thickness,convexity=2) difference() {
        offset(r=lip_width+outer_offset)square([x-lip_width,y-lip_width],center=true);
        square([polarizer_x-2*inner_offset,polarizer_y-2*inner_offset],center=true);
      }   
    if(upper_feature)translate([0,0,thickness])contact_line();
    }
    if(lower_feature) translate([0,0,-bissl])contact_line();
    for (i=[-0.5,0.5]) for (j=[-0.5,0.5]) 
      translate([i*(polarizer_x+lip_width+outer_offset-inner_offset),j*(polarizer_y+lip_width+outer_offset-inner_offset),-bissl])
        cylinder(d=d,h=thickness+lip_width/2+2*bissl);
  }
}
  layer(hor_wall,true,false);