$fs=1/2;
$fa=1/2;
bsl=1/100;

part="fret_press";//[fret_press, neck support]

radius_fretboard=16*25.4; //fret is bent to this radius
radius_fret=1.75; //curvature of a fret crown
radius_neck=40; //curvature of back side of the neck
rounding=2; //fillet

length_fret=55; //neck width or more if multiscale
support_block=[25,30]; //back side of the neck
support_thickness=4; //extra material in neck support to distribute the load

press_width=10; //fret-pressing part as it widens
press_thickness=2; //extra material in fret press to distribute the load
clamp_size=18; //diameter of the clamp coupling
clamp_depth=3; //depression for the clamp to be locked in

module neck_support() {
  difference() {
    linear_extrude(radius_neck) {
      offset(r=rounding) offset(r=-rounding) square(support_block,center=true);
    }
   translate([0,0,radius_neck+support_thickness+clamp_depth])rotate([0,90,0])cylinder(r=radius_neck,h=max(support_block)+bsl,center=true);
   translate([0,0,-bsl]) cylinder(d=clamp_size,h=clamp_depth+bsl);
  }
}

module fret_press() {
  module fret_profile() {
    translate([-press_width/2-radius_fretboard+radius_fret,0])difference() {
      polygon([[-press_thickness,-press_width/2],
               [0,-press_width/2],
               [press_width/2,-radius_fret],
               [press_width/2,radius_fret],
               [0,press_width/2],
               [-press_thickness,press_width/2]]);
      translate([press_width/2,0])circle(r=radius_fret);
    }
  }
  intersection() {
    translate([0,0,radius_fretboard+press_width/2-radius_fret]) rotate([90,0,0])rotate_extrude() fret_profile();
    linear_extrude(radius_fretboard,center=true) offset(r=rounding) offset(r=-rounding) {
      square([length_fret,press_width],center=true);
    }
  }
}

module fret_press_holder() {
  shift=radius_fretboard-sqrt(radius_fretboard^2-(length_fret/2)^2);
  translate([0,0,press_thickness])fret_press();
  difference() {
    hull() {
      linear_extrude(shift) offset(r=rounding) offset(r=-rounding) {
        square([length_fret,press_width],center=true);
      }
      translate([0,0,-length_fret/2+clamp_size/2]) cylinder(d=clamp_size+2*clamp_depth,h=clamp_depth);
    }
    translate([0,0,-bsl-length_fret/2+clamp_size/2]) cylinder(d=clamp_size,h=clamp_depth);
  }
}

if (part=="fret_press") fret_press_holder();
if (part=="neck_support") neck_support();
if (part=="debug") fret_press();