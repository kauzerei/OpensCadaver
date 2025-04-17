//A holder for a small power distributing PCB
//Project: magnetic mounting system for making videos on a table surface
$fs=1/1;
$fa=1/1;
bissl=1/100;
part="bottom";//[bottom,top]
width=14;
height=34;
thickness=4;
wall=1.6;
hole=3;
border=1.5;
difference() {
  cube([width+2*wall,height+4*wall+2*hole,thickness/2+wall],center=true);
  translate([0,0,wall/2+bissl])cube([width,height,thickness/2],center=true);
  translate([0,height/2+2*wall,0]) cylinder(d=hole,h=wall+thickness/2+bissl,center=true);
  translate([0,-height/2-2*wall,0]) cylinder(d=hole,h=wall+thickness/2+bissl,center=true);
  if (part=="top") translate([0,0,-wall/2-bissl])cube([width-2*border,height-2*border,thickness/2],center=true);
}