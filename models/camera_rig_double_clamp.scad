//Double clamps for mounting stuff on camera rails
//Customizations allow to use this single parametric model to generate all of the rail mounts for my rig.
//Make neighboring tightener thumb screws face different directions for ease of their use in otherwise tight space
//Mount objects above or below the clamp
//Move the mounting height by changing the position of connecting bar between rail clamps
//Coupling option allows to attach Hirth joint rosette and use it for example for clamping to another tube
//I'm using m4 screws in 10x10mm grid in my diy rigs, if you want more standard 1/4" screws with 9x9mm grid just change d_bolt to 6.5 and hole_distance to 9
$fa=1/1;
$fs=1/2;
bissl=1/100;
/* [hardware size] */
d_tube=16;
h_ring=12;
d_bolt=4;
d_nut=8;
h_nut=4;
/* [coupling size] */
coupling=false;
bcd=10;
n_screws=4;
d_circle=2;
/* [general part parameters] */
wall=3;
offset=1;
center_to_center=60;
connect_thickness=6;
n_holes=3;
hole_distance=10;
/* [part shape tweaks] */
nut=true;
invert_nut_side=false;
tightener_facing="up";//[down,side,diagonally_up,diagonally_down,diagonally_inwards]
angle=tightener_facing=="up"?180:
      tightener_facing=="diagonally_up"?135:
      tightener_facing=="side"?90:
      tightener_facing=="diagonally_down"?45:
      tightener_facing=="down"?0:
      tightener_facing=="diagonally_inwards"?-150:undef;
nut_side_up=(tightener_facing=="up" || tightener_facing=="diagonally_up" || tightener_facing=="diagonally_inwards");
reflections=invert_nut_side?[!nut_side_up,nut_side_up]:[nut_side_up,!nut_side_up];
orientations=[-angle,angle];
connect_position="low";//[mid,up,just_clear_nut]
mount_object="down";//[up,side]
holes_orientation=mount_object=="down"?90:
                  mount_object=="up"?-90:
                  mount_object=="side"?0:undef;
connect_offset=connect_position=="low"?connect_thickness/2-d_tube/2-wall:
               connect_position=="mid"?0:
               connect_position=="up"?-connect_thickness/2+d_tube/2+wall:
               nut_side_up?d_tube/2+offset+d_bolt/2-d_nut/2-connect_thickness/2:
               -d_tube/2-offset-d_bolt/2+d_nut/2+connect_thickness/2;


module single_clamp() {
  difference() {
    union() {
      hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
    }
    translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset,-d_tube/2,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_nut,$fn=6);
  if (coupling) translate([-d_bolt/2-offset,d_tube/2+wall,0]) rotate([90,0,0]) for (i=[180/n_screws:360/n_screws:360]) rotate([0,0,i])translate([bcd/2,0,-0.01]) cylinder(h=2*wall+0.02,d=d_circle);
    translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
  }
}
module double_clamp() {
  difference() {
    union() {
      hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
        translate([0,center_to_center,0]) hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
      translate([d_tube+wall-connect_thickness,0,-h_ring/2])cube([connect_thickness,center_to_center,h_ring]);
      
    }
    translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
    translate([d_tube/2,center_to_center,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset,-d_tube/2+center_to_center,0]) rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
  if (nut) translate([-d_bolt/2-offset,d_tube/2+wall+bissl,0]) rotate([90,0,0]) cylinder(h=wall+bissl, d=d_nut,$fn=6);
    translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-offset,center_to_center,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall+center_to_center,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
    for (i=[20,30,40]) {
      translate([-connect_thickness+d_tube+wall-bissl,i,0])rotate([90,0,90])cylinder(d=d_nut, h=h_nut,$fn=6);
      translate([-connect_thickness+d_tube+wall-bissl,i,0])rotate([90,0,90])cylinder(d=d_bolt, connect_thickness+2*bissl);
    }
  }
}
module double_clamp_wall() {
  connect_thickness=5;
  h_ring=12;
  difference() {
    union() {
      hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
        translate([0,center_to_center,0]) hull() {
        translate([d_tube/2,0,0])cylinder(h=h_ring, d=d_tube+2*wall,center=true);
        translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall, d=h_ring,center=true);
      }
      translate([d_tube/2,0,-h_ring/2])hull() {
      for (t=[[-85+31+5,10,0],[-85+31+5,50,0],[0,10,0],[0,50,0]]) translate(t) cylinder (d=10,h=connect_thickness);
      }
    }
translate([d_tube/2,0,-h_ring/2-bissl]) for (t=[[-85+31+5,10,0],[-85+31+5,30,0],[-85+31+5,50,0]]) translate(t) cylinder (d=d_bolt,h=connect_thickness+2*bissl);
      
    translate([d_tube/2,0,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
    translate([d_tube/2,center_to_center,0])cylinder(h=d_tube+2*wall+bissl, d=d_tube,center=true);
  if (nut) translate([-d_bolt/2-offset,-d_tube/2+center_to_center,0]) rotate([90,0,0]) cylinder(h=wall+h_nut*2, d=d_nut,$fn=6);
  if (nut) translate([-d_bolt/2-offset,d_tube/2,0]) rotate([-90,0,0]) cylinder(h=wall+h_nut*2, d=d_nut,$fn=6);
    translate([-d_bolt/2-offset,0,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-offset,center_to_center,0]) rotate([90,0,0]) cylinder(h=d_tube+2*wall+bissl, d=d_bolt,center=true);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
    translate([-d_bolt/2-h_ring/2-bissl-offset,-d_tube/2+wall+center_to_center,-h_ring/2-bissl])cube([d_bolt/2+h_ring/2+d_tube/2+offset,d_tube-2*wall,h_ring+2*bissl]);
  }
}
//single_clamp();
//double_clamp_wall();
//clamp();
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
    rotate([90,0,0]) cylinder(h=3*h_nut, d=d_nut,$fn=6);
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
module clamp_double(d_tube=16,h_ring=12,wall=3,d_bolt=4,
             offset=1,nut=true,d_nut=8,h_nut=4,
             coupling=false,bcd=10,n_screws=4,d_circle=2,
             center_to_center=60,orientations=[0,0],reflections=[false,true],
             connect_thickness=8,connect_offset=5,n_holes=3,hole_distance=10,holes_orientation=0) {
  difference() {
    union() {
      translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([connect_offset,0,0])cube([connect_thickness,center_to_center,h_ring],center=true);
      
    }
    translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]]) mirror([0,reflections[0]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);    
    translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])  mirror([0,reflections[1]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
    translate([connect_offset,0,0]) 
      for (t=[-hole_distance*(n_holes-1)/2:hole_distance:hole_distance*(n_holes-1)/2])
        translate([0,t,0]) rotate([0,holes_orientation,0]) {
          cylinder(h=max(connect_thickness,h_ring)+bissl,d=d_bolt,center=true);
          rotate([0,0,90])cylinder(h=max(connect_thickness,h_ring)/2+bissl,d=d_nut,$fn=6);
        }
  }             
}
clamp_double(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,h_nut=h_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle,
             center_to_center=center_to_center,orientations=orientations,reflections=reflections,
             connect_thickness=connect_thickness,connect_offset=connect_offset,
             n_holes=n_holes,hole_distance=hole_distance,holes_orientation=holes_orientation);
module bar(bar_thickness=6,center_to_center=60,h_ring=16,hole_distance=10,nholes=5,d_bolt=4,d_nut=8,h_nut=4) {
  difference() {
    cube([bar_thickness,center_to_center,h_ring],center=true);
    for (t=[-hole_distance*(n_holes-1)/2:hole_distance:hole_distance*(n_holes-1)/2])
      translate([0,t,0]) rotate([0,holes_orientation,0]) {
        cylinder(h=bar_thickness+bissl,d=d_bolt,center=true);
        rotate([0,0,90])cylinder(h=max(connect_thickness,h_ring)/2+bissl,d=d_nut,$fn=6);
    }
  }
}
module double_double_clamp() {
clamp_double(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,h_nut=h_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle,
             center_to_center=center_to_center,orientations=orientations,reflections=reflections,
             connect_thickness=connect_thickness,connect_offset=connect_thickness/2-d_tube/2-wall,
             n_holes=n_holes,hole_distance=hole_distance,holes_orientation=90);
 clamp_double(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,h_nut=h_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle,
             center_to_center=center_to_center,orientations=orientations,reflections=reflections,
             connect_thickness=connect_thickness,connect_offset=-connect_thickness/2+d_tube/2+wall,
             n_holes=n_holes,hole_distance=hole_distance,holes_orientation=-90);
 }
 *bar();