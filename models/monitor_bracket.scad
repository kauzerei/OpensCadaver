width=85;
height=55;
wall=3;
depth=21;
taper=4;
$fa=1/1;
$fs=1/2;
bissl=1/100;
d_bolt=4;
d_nut=8;
h_nut=4;
bcd=12;
n_screws=4;
d_circle=2;
back_plate=4;
module bracket() {
  difference() {
    cube([width+wall,height+wall,depth+back_plate]);
    hull() {
      for (t=[[taper+wall,taper+wall,0],[taper+wall+width,taper+wall,0],[taper+wall+width,taper+wall+height,0],[taper+wall,taper+wall+height,0],[taper+wall,taper+wall+height,2]]) translate(t) {
        translate([0,0,-bissl])cylinder(d1=0,d2=2*taper,h=taper);
        translate([0,0,taper-bissl]) cylinder(d=2*taper,h=depth-taper+2*bissl);
        *translate([0,0,depth-taper+bissl])cylinder(d2=0,d1=2*taper,h=taper);
      }
    }
    translate([wall+taper+8,wall+taper+8,depth-bissl])cube([width,height,back_plate+2*bissl]);
    translate([wall+taper,wall+taper,depth-bissl]) {
      for (tr=[[4,35,0],[4,45,0],[64,2,0],[74,2,0]]) translate(tr)cylinder(h=back_plate+2*bissl,d=4);
    }
    translate([0,46,wall/2+depth/2])rotate([0,90,0]) translate([0,0,-bissl]) {
    cylinder(h=h_nut+2*bissl, d=d_nut,$fn=6);
    for (i=[180/n_screws:360/n_screws:360]) rotate([0,0,i])translate([bcd/2,0,-0.01]) cylinder(h=2*wall+0.02,d=d_circle);
    }
  }
}
module rosette_mount() {
difference() {
  cylinder(h=wall,d=depth+back_plate);
  *translate([0,0,-bissl]) cylinder(h=h_nut+2*bissl, d=d_nut,$fn=6);
  translate([0,0,-bissl]) cylinder(h=wall+2*bissl, d=d_bolt);
  for (i=[180/n_screws:360/n_screws:360]) rotate([0,0,i])translate([bcd/2,0,-0.01]) cylinder(h=2*wall+0.02,d=d_circle);
}
}
translate([0,46,back_plate/2+depth/2])rotate([0,-90,0])rosette_mount();
bracket();