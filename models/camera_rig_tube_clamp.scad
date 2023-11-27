//Thing to be mounted on round tubes like camera rig rails, stabilizer sledge, tripod legs, etc.
//The idea is to use two of those to connect two tubes either directly or through Hirth Joint
//Such clamp pairs can hold everything rod-mounted to a camera rig: monitor, follow-focus, etc. 
$fa=1/1;
$fs=1/2;
bissl=1/100;
/* [hardware size] */
d_tube=16;
h_ring=12;
d_bolt=4;
d_nut=8;
/* [coupling size] */
coupling=false;
bcd=10;
n_screws=4;
d_circle=2;
/* [general part parameters] */
wall=3;
offset=1;
nut=true;

module clamp_positive(d_tube=16,h_ring=12,wall=3,d_bolt=4,offset=1) {
  hull () {
    translate([0,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
    translate([-d_bolt/2-offset-d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
  }
}

module clamp_negative(d_tube=16,h_ring=12,wall=3,d_bolt=4,
                      offset=1,nut=true,d_nut=8,
                      coupling=false,bcd=10,n_screws=4,d_circle=2) {
  cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset-d_tube/2,-d_tube/2,0])
    rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
  if (coupling) translate([-d_bolt/2-offset-d_tube/2,d_tube/2+wall,0]) rotate([90,0,0])
    for (i=[180/n_screws:360/n_screws:360]) rotate([0,0,i]) translate([bcd/2,0,-0.01])
      cylinder(h=2*wall+0.02,d=d_circle);
  translate([-d_bolt/2-offset-d_tube/2,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
  translate([-d_bolt/2-h_ring/2-bissl-offset-d_tube/2,-d_tube/2+wall,-h_ring/2-bissl]) 
    cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
}
module clamp(d_tube=16,h_ring=12,wall=3,d_bolt=4,
             offset=1,nut=true,d_nut=8,
             coupling=false,bcd=10,n_screws=4,d_circle=2) {
  difference() {
    clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
    clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
  }             
}

clamp(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);