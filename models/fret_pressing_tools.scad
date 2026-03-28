//Tools that couple with a weird clamp I have to press guitar frets into fingerboard
//or to hold them in place during glueing
//Initially designed to fix my 8 string

$fs=1/4;
$fa=1/4;
bsl=1/100;

part="fret_press";//[fret_press, neck_support]

radius_fretboard=16*25.4; //fret is bent to this radius
radius_fret=1.75; //curvature of a fret crown
radius_neck=40; //curvature of back side of the neck
rounding=4; //fillet

length_fret=55; //neck width or more if multiscale
support_block=[25,30]; //back side of the neck
support_thickness=4; //extra material in neck support to distribute the load

press_width=10; //fret-pressing part as it widens
press_thickness=4; //extra material in fret press to distribute the load
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

if (part=="fret_press") fret_press_holder();
if (part=="neck_support") neck_support();
if (part=="debug") fret_press();

module dome(d,h) {
  translate([0,0,h]) intersection() {
    sphere(d=d);
    cylinder(d=d,h=d/2);
  }
  cylinder(d=d,h=h);
}

module blank() {
  difference() {
    hull() {
      translate([0,0,-press_thickness-length_fret/2+clamp_size/2+clamp_depth]) {
        dome(d=clamp_size+2*clamp_depth,h=clamp_depth);
      }
      for (tr=[[-length_fret/2+rounding,-press_width/2+rounding],
              [-length_fret/2+rounding,press_width/2-rounding],
              [length_fret/2-rounding,-press_width/2+rounding],
              [length_fret/2-rounding,press_width/2-rounding]]) {
        translate(tr) mirror([0,0,1]) dome(d=rounding,h=press_thickness);
      }
    }
    translate([0,0,-press_thickness-length_fret/2+clamp_size/2+clamp_depth-bsl]) {
      cylinder(d=clamp_size,h=clamp_depth);
    }
  }
}

module profile() {
  translate([-radius_fret,0]) {
    rotate(-45) difference() {
      square(100,center=true);
      square(100);
    }
    circle(r=radius_fret);
  }
}

module fret_press_holder() {
  difference() {
    blank();
    translate([0,0,radius_fretboard-radius_fret])rotate([90,0,0]) {
      rotate_extrude() translate([radius_fretboard,0]) profile();
    }
  }
}