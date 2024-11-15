$fa=1/1;
$fs=1/2;
bissl=1/100;
thickness=8;
width=122;
height=79+60;
lip=3;
wall=2;
d=4;
part="frame"; //[frame,hinge]
if (part=="frame") difference() {
  union() {
    cube([width+2*wall,height,thickness+2*lip]);
    translate([-bissl,height,thickness/2+lip])rotate([0,90,0])cylinder(d=thickness+2*lip,h=width+2*wall+2*bissl);
  }
  hull() {
    translate([wall,wall,lip])cube([width,height+thickness/2+lip,thickness]);
    translate([wall+lip,wall+lip,-bissl])cube([width-2*lip,height+thickness/2+lip,thickness+2*lip+2*bissl]);
  }
  translate([-2*bissl,height,thickness/2+lip])rotate([0,90,0])cylinder(d=d,h=width+2*wall+4*bissl);
}
if (part=="hinge") {
  for (m=[[0,0,0],[1,0,0]]) mirror(m) difference() 
  {
  union()
  {
    translate([width/2+wall,0,0]) rotate([0,90,0])cylinder(d=thickness+2*lip,h=wall);
    translate([width/2+wall,-thickness/2-lip,-thickness-2*lip]) cube([wall,thickness+2*lip,thickness+2*lip]);
    translate([0,-thickness/2-lip,-thickness-2*lip]) cube([width/2+wall,thickness+2*lip,wall]);
  }
  translate([width/3,0,0])cylinder(d=d,2*thickness+5*lip,center=true);
  translate([width/2+wall-bissl,0,0]) rotate([0,90,0])cylinder(d=d,h=wall+2*bissl);
  }
}