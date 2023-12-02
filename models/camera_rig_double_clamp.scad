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
part="single_clamp";//[double_clamp,double_clamp_side,double_clamp_double_mount,lens_suppoprt_clamp,lens_support]
/* [hardware size] */
d_tube=16;
h_ring=16;
d_bolt=4;
d_nut=8;
h_nut=3;
/* [coupling size] */
coupling=false;
bcd=10;
n_screws=4;
d_circle=2;
/* [general part parameters] */
wall=3;
offset=1;
center_to_center=60;
bar_thickness=6;
n_holes=3;
hole_distance=10;
/* [lens support] */
range=30;
width=20;
maxlens=82;
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
bar_position="low";//[mid,up,just_clear_nut]
mount_object="down";//[up,down]
bar_orientation=mount_object=="down"?180:
                  mount_object=="up"?0:undef;
bar_offset=bar_position=="low"?bar_thickness/2-d_tube/2-wall:
               bar_position=="mid"?0:
               bar_position=="up"?-bar_thickness/2+d_tube/2+wall:
               nut_side_up?d_tube/2+offset+d_bolt/2-d_nut/2-bar_thickness/2:
               -d_tube/2-offset-d_bolt/2+d_nut/2+bar_thickness/2;


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
      translate([d_tube+wall-bar_thickness,0,-h_ring/2])cube([bar_thickness,center_to_center,h_ring]);
      
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
      translate([-bar_thickness+d_tube+wall-bissl,i,0])rotate([90,0,90])cylinder(d=d_nut, h=h_nut,$fn=6);
      translate([-bar_thickness+d_tube+wall-bissl,i,0])rotate([90,0,90])cylinder(d=d_bolt, bar_thickness+2*bissl);
    }
  }
}
module double_clamp_wall() {
  bar_thickness=5;
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
      for (t=[[-85+31+5,10,0],[-85+31+5,50,0],[0,10,0],[0,50,0]]) translate(t) cylinder (d=10,h=bar_thickness);
      }
    }
translate([d_tube/2,0,-h_ring/2-bissl]) for (t=[[-85+31+5,10,0],[-85+31+5,30,0],[-85+31+5,50,0]]) translate(t) cylinder (d=d_bolt,h=bar_thickness+2*bissl);
      
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
  if (nut) translate([-d_bolt/2-offset-d_tube/2,-wall-d_tube/2-bissl,0])
    rotate([-90,0,0]) cylinder(h=h_nut+bissl, d=d_nut,$fn=6);
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
             bar_thickness=8,bar_offset=5,n_holes=3,hole_distance=10,bar_orientation=0) {
  difference() {
    union() {
      translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([bar_offset,0,0]) rotate([0,bar_orientation,0])bar(bar_thickness=bar_thickness,center_to_center=center_to_center,bar_width=h_ring,hole_distance=hole_distance,n_holes=n_holes,d_bolt=d_bolt,d_nut=d_nut,h_nut=h_nut);
      
    }
    translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]]) mirror([0,reflections[0]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);    
    translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])  mirror([0,reflections[1]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
  }             
}
module bar(bar_thickness=6,center_to_center=60,bar_width=16,hole_distance=10,n_holes=5,d_bolt=4,d_nut=8,h_nut=4) {
  difference() {
    cube([bar_thickness,center_to_center,bar_width],center=true);
    for (t=[-hole_distance*(n_holes-1)/2:hole_distance:hole_distance*(n_holes-1)/2])
      translate([0,t,0]) rotate([0,90,0]) {
        cylinder(h=bar_thickness+bissl,d=d_bolt,center=true);
        rotate([0,0,90])translate([0,0,-bar_thickness/2-bissl])cylinder(h=h_nut+bissl,d=d_nut,$fn=6);
    }
  }
}
module double_double_clamp(d_tube=16,h_ring=12,wall=3,d_bolt=4,
             offset=1,nut=true,d_nut=8,h_nut=4,
             coupling=false,bcd=10,n_screws=4,d_circle=2,
             center_to_center=60,orientations=[0,0],reflections=[false,true],
             bar_thickness=8,second_bar_offset=5,n_holes=3,hole_distance=10) {
  difference() {
    union() {
      translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([bar_thickness/2-d_tube/2-wall,0,0]) rotate([0,180,0])bar(bar_thickness=bar_thickness,center_to_center=center_to_center,bar_width=h_ring,hole_distance=hole_distance,n_holes=n_holes,d_bolt=d_bolt,d_nut=d_nut,h_nut=h_nut);
      translate([second_bar_offset,0,0]) rotate([0,0,0])bar(bar_thickness=bar_thickness,center_to_center=center_to_center,bar_width=h_ring,hole_distance=hole_distance,n_holes=n_holes,d_bolt=d_bolt,d_nut=d_nut,h_nut=h_nut);      
    }
    translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]]) mirror([0,reflections[0]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);    
    translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])  mirror([0,reflections[1]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
  }             
}
module clamp_double(d_tube=16,h_ring=12,wall=3,d_bolt=4,
             offset=1,nut=true,d_nut=8,h_nut=4,
             coupling=false,bcd=10,n_screws=4,d_circle=2,
             center_to_center=60,orientations=[0,0],reflections=[false,true],
             bar_thickness=8,bar_offset=5,n_holes=3,hole_distance=10,bar_orientation=0) {
  difference() {
    union() {
      translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([bar_offset,0,0]) rotate([0,bar_orientation,0])bar(bar_thickness=bar_thickness,center_to_center=center_to_center,bar_width=h_ring,hole_distance=hole_distance,n_holes=n_holes,d_bolt=d_bolt,d_nut=d_nut,h_nut=h_nut);
      
    }
    translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]]) mirror([0,reflections[0]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);    
    translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])  mirror([0,reflections[1]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
  }             
}
 
module clamp_double_side(d_tube=16,h_ring=12,wall=3,d_bolt=4,
             offset=1,nut=true,d_nut=8,h_nut=4,
             coupling=false,bcd=10,n_screws=4,d_circle=2,
             center_to_center=60,orientations=[0,0],reflections=[false,true],
             bar_thickness=8,bar_offset=5,n_holes=3,hole_distance=10,bar_orientation=0) {
  difference() {
    union() {
      translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])
        clamp_positive(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,offset=offset);
      translate([bar_offset,0,0]) rotate([0,-90,0])bar(bar_thickness=h_ring,center_to_center=center_to_center,bar_width=bar_thickness,hole_distance=hole_distance,n_holes=n_holes,d_bolt=d_bolt,d_nut=d_nut,h_nut=h_nut);
      
    }
    translate([0,center_to_center/2,0]) rotate([0,0,orientations[0]]) mirror([0,reflections[0]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);    
    translate([0,-center_to_center/2,0]) rotate([0,0,orientations[1]])  mirror([0,reflections[1]?1:0,0])
      clamp_negative(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
                     offset=offset,nut=nut,d_nut=d_nut,
                     coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
    translate([bar_offset-bar_thickness/2-bissl,-width/2,0])cube([bar_thickness+2*bissl,width+2*bissl,h_ring/2+bissl]);
  }             
}
module lens_support(range=30,wall=3,width=20,maxlens=82,h_ring=16,bissl=1/100) {
  difference() {
    union() {
      points=[[-range-2*wall,width/2-wall/2],[(width/2-wall/2)/2,width/2-wall/2],[(maxlens/2)/2,maxlens/2],[0,0],[(maxlens/2)/2,-maxlens/2],[(width/2-wall/2)/2,wall/2-width/2],[-range-2*wall,wall/2-width/2]];
      for (i=[0:len(points)-1]) hull() {
        translate(points[i%len(points)])cylinder(h=h_ring/2,d=wall);
        translate(points[(i+1)%len(points)])cylinder(h=h_ring/2,d=wall);
      }
    linear_extrude(height=h_ring/2,convexity=4) polygon(points);
    }
    hull() {
      translate([-range-wall,0,-bissl]) cylinder(d=d_bolt, h=h_ring/2+2*bissl);
      translate([-wall,0,-bissl]) cylinder(d=d_bolt, h=h_ring/2+2*bissl);
    }
  }
}
if(part=="lens_support")lens_support(range=range,wall=wall,width=width,maxlens=maxlens,h_ring=h_ring);
if(part=="double_clamp_side")clamp_double_side(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,h_nut=h_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle,
             center_to_center=center_to_center,orientations=orientations,reflections=reflections,
             bar_thickness=bar_thickness,bar_offset=bar_offset,
             n_holes=n_holes,hole_distance=hole_distance,bar_orientation=bar_orientation);
if(part=="double_clamp")clamp_double(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,h_nut=h_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle,
             center_to_center=center_to_center,orientations=orientations,reflections=reflections,
             bar_thickness=bar_thickness,bar_offset=bar_offset,
             n_holes=n_holes,hole_distance=hole_distance,bar_orientation=bar_orientation);
if(part=="single_clamp") clamp(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle);
if(part=="double_clamp_double_mount")double_double_clamp(d_tube=d_tube,h_ring=h_ring,wall=wall,d_bolt=d_bolt,
             offset=offset,nut=nut,d_nut=d_nut,h_nut=h_nut,
             coupling=coupling,bcd=bcd,n_screws=n_screws,d_circle=d_circle,
             center_to_center=center_to_center,orientations=orientations,reflections=reflections,
             bar_thickness=bar_thickness,second_bar_offset=bar_offset,
             n_holes=n_holes,hole_distance=hole_distance);
