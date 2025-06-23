//Frame for using plain film or photopaper in glass plate camera
//Supposed to be supported from the other side with some smaller sized plate
//Too bendy, I ended up using part made of harder materials
width=89;
height=119;
depth=1.5;
thickness=0.2;
wall=0.8;
border=1.6;
air=0.5;
difference() {
  cube([width,height,depth]);
  translate([wall,wall,thickness]) cube([width-2*wall,height-2*wall,depth]);
  translate([wall+border,wall+border,-0.01]) cube([width-2*wall-2*border,height-2*wall-2*border,depth]);
}
*cube([width-2*wall-2*air,height-2*wall-air*2,depth]); //this can be the plate
