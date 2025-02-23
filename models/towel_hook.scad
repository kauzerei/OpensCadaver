// Hook for the towel drier
$fn=64;
thickness=6; //height of print
width=6; //  
id1=10;
angle1=250;
id2=22;
angle2=230;
intersection(){
union(){
linear_extrude(height=thickness-width/2,center=true) s(id1,angle1,id2,angle2,width);
translate([0,0,thickness/2-width/4]) roof() s(id1,angle1,id2,angle2,width);
mirror([0,0,1])translate([0,0,thickness/2-width/4]) roof() s(id1,angle1,id2,angle2,width);
}
cube([2*max(id1,id2)+4*width,2*max(id1,id2)+4*width,thickness],center=true);
}
module s(id1,angle1,id2,angle2,width) {
  translate([-id1/2-width/2,0,0]) for (angle=[0:1:angle1]) hull() {
    rotate([0,0,angle])translate([id1/2+width/2,0,0])circle(d=width);
    rotate([0,0,angle+1])translate([id1/2+width/2,0,0])circle(d=width);
  }
  rotate([0,0,180])translate([-id2/2-width/2,0,0]) for (angle=[0:1:angle2]) hull() {
    rotate([0,0,angle])translate([id2/2+width/2,0,0])circle(d=width);
    rotate([0,0,angle+1])translate([id2/2+width/2,0,0])circle(d=width);
  }
}


