// Arm with two arri rosette mounts on each side
// Probably should become a part of rig-htsized repo
length=100;
depth=10;
wall=3;
width=20;
d_nut=8;
d_bolt=4;
bcd=12;
bd=2;
nb=4;
$fa=1/1;
$fs=1/2;
bissl=1/100;
module arm_for_rosette(length=40,depth=10,wall=3,width=20,d_nut=8,d_bolt=4,bcd=12,bd=2,nb=4,bissl=1/100) {
  difference() {
    hull() {
      rosette_holder(depth=depth,wall=wall,diameter=width,d_nut=d_nut,d_bolt=d_bolt,bcd=bcd,bd=bd,nb=nb,bissl=1/100,negative=false);
      translate([length,0,0]) rosette_holder(depth=depth,wall=wall,diameter=width,d_nut=d_nut,d_bolt=d_bolt,bcd=bcd,bd=bd,nb=nb,bissl=1/100,negative=false);
    }
      rosette_holder(depth=depth,wall=wall,diameter=width,d_nut=d_nut,d_bolt=d_bolt,bcd=bcd,bd=bd,nb=nb,bissl=1/100,negative=true);
      rotate([180,0,0])translate([length,0,-depth]) rosette_holder(depth=depth,wall=wall,diameter=width,d_nut=d_nut,d_bolt=d_bolt,bcd=bcd,bd=bd,nb=nb,bissl=1/100,negative=true);
  }
}

module rosette_holder(depth=10,wall=3,diameter=20,d_nut=8,d_bolt=4,bcd=12,bd=2,nb=4,bissl=1/100,negative=false) {
  difference() {
    if (!negative) cylinder(h=depth,d=diameter);
      union() {
        translate([0,0,-bissl]) cylinder(h=depth+2*bissl, d=d_bolt);
        for (i=[180/nb:360/nb:360]) rotate([0,0,i])translate([bcd/2,0,-bissl]) cylinder(h=depth+2*bissl,d=bd);
        translate([0,0,-depth]) cylinder(d=d_nut,h=2*depth-wall,$fn=6);
      }
  }
}
//arm_for_rosette(length=length,depth=depth,wall=wall);
arm_for_rosette(length=length,depth=depth,wall=wall,width=width,d_nut=d_nut,d_bolt=d_bolt,bcd=bcd,bd=bd,nb=nb,bissl=1/100);