//A part to repair my tiny card-reader. Not really useful or reusable
thickness=0.4;
width=11.4;
height=2.2;
depth=11;
bissl=1/1000;
*linear_extrude(depth)difference() {
  square([width,height],center=true);
  translate([0,thickness/2]) square([width-2*thickness,height-thickness+bissl],center=true);
}
linear_extrude(depth)difference() {
  square([width,height],center=true);
  translate([0,height/2]) square([width-2*thickness,height-thickness+bissl],center=true);
  translate([0,-height/2]) square([width-2*thickness,height-thickness+bissl],center=true);
}
