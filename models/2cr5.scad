$fa=1/1;
$fs=1/2;
bissl=1/100;
d123=17;
neck=14;
wall=0.4;
air=0.5;
height=30;
contact=5;
module crosssection(d123,neck) {
  translate([d123/2,d123/2])circle(d=d123);
  translate([d123/2,-d123/2])circle(d=d123);
  translate([0,-d123/2])square([neck,d123]);
}
//crosssection(d123,neck);
module case(d123=d123,neck=neck,wall=wall,height=height,contact=contact){
  difference(){
    linear_extrude(height=height,convexity=4 ) crosssection(d123,neck);
    translate([0,0,wall])linear_extrude(height=height,convexity=4 ) offset(r=-wall) crosssection(d123,neck);
    translate([d123-contact+bissl,d123/2-contact/2,-bissl])cube([contact,contact,contact]);
    translate([d123-contact+bissl,-d123/2-contact/2,-bissl])cube([contact,contact,contact]);
  }
}
module insert(d123=d123,neck=neck,wall=wall,height=height,contact=contact,air=air) {
  translate([0,0,wall+air])linear_extrude(height=height-wall-air) offset(r=-wall-air) crosssection(d123,neck);
}
case();
insert();