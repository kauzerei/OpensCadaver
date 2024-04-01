$fa=1/1;
$fs=1/2;
bissl=1/100;
part="insert";//[insert,case,all]
d123=17;
neck=14;
wall=0.5;
air=0.5;
height=45;
contact=4;
d_cell=13;
h_cell=40;
d_wire=2;
wires=[ //[x_start,y_start,z_start],[x_end,y_end,z_end],diameter
  [[d123/2,d123/2,d_wire/2-bissl],[d123/2,d123/2,d_wire/2-bissl+h_cell],d_wire], //dcdc-contact
  [[d123/2,-d123/2,d_wire/2-bissl],[d123/2-d123/4,-d123/2,d_wire/2-bissl],d_wire], //bottom-contact
  [[d123/2-d123/4,d123/2,d_wire/2-bissl],[d123/2-d123/4,-d123/2,d_wire/2-bissl],d_wire], //bottom straight
  [[d123/2-d123/4,d123/2,d_wire/2-bissl],[d123/2-d123/4,d123/2,d_wire/2-bissl+h_cell],d_wire], //dcdc-bottom
  [[d123/2-d123/4,d123/2,h_cell],[d123/2-d123/4,-d123/2,h_cell],d_wire], //battery-dcdc upper
  [[d123/2-d123/4,d123/2,h_cell-2*d_wire],[d123/2-d123/4,-d123/2,h_cell-2*d_wire],d_wire], //battery-dcdc lower
  ];
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
  difference () {
    linear_extrude(height=height-wall-air,convexity=4) offset(r=-wall-air) crosssection(d123,neck);
    
    //cell:
    hull() {
      translate([d123/2,-d123/2,height-wall-air-h_cell-1])cylinder(d=d_cell,h=h_cell);
      translate([0,-d123/2,height-wall-air-h_cell-1])cylinder(d=d_cell,h=h_cell);
    }
    
    //charger:
    *translate([1.5,0.4,10]) rotate([0,0,-20]) charger();   
    
    //step up
    *translate([6.5,1.5,10])rotate([0,0,-20]) boost();
    
    //second compartment
    hull() {
      translate([d123/2,d123/2,height-wall-air-h_cell-1])cylinder(d=d_cell,h=h_cell);
      translate([0,d123/2,height-wall-air-h_cell-1])cylinder(d=d_cell,h=h_cell);
    }
    midpart=d123-d_cell;
    translate([wall+air-1,1-midpart/2,height-wall-air-h_cell-1])cube([neck-2*wall-2*air,midpart,h_cell]);
    
    
    //wires
    for (wire=wires) {
      hull() {
        translate(wire[0]) cube([wire[2],wire[2],wire[2]],center=true);
        translate(wire[1]) cube([wire[2],wire[2],wire[2]],center=true);
      }
    }
  }
}
module charger(){
  cube([3,18,height-wall-air-11]);
  translate([0.5,5,height-wall-air-6+2*bissl-10])cube([3,13,6]);
}
module boost(){
  cube([5,15,height-wall-air+2*bissl]);
}
//case();
//translate([0,0,wall+air]) 
//insert();
if (part=="case") case();
if (part=="insert") rotate([0,180,0])insert();
if (part=="all") {
  case();
  translate([0,0,wall+air]) insert();
  }