//a back plate to apply the pressure when glueing the back of the phone

width=70;
height=148;
back_rim_width=7;
side_rim_width=5;
back_rim_thickness=3;
side_rim_thickness=3;
bissl=1/100;

difference() {
  cube([width+2*side_rim_thickness,height+2*side_rim_thickness,back_rim_thickness+side_rim_width]);
  translate([side_rim_thickness,side_rim_thickness,back_rim_thickness]) {
    cube([width,height,side_rim_width+bissl]);
  }
  translate([side_rim_thickness+back_rim_width,side_rim_thickness+back_rim_width,-bissl]) {
    cube([width-2*back_rim_width,height-2*back_rim_width,back_rim_thickness+2*bissl]);
  }
}