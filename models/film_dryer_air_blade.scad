//Nozzle for quickly removing water droplets from wet film
//Still work in progress, I'm yet to find the right parameters
blade_height=50;
blade_thickness=2;
blade_protrusion=20;
blade_diameter=21;
blade_curvature=0.9;
wall=1.6;
angle=30;
offset=10;
blower_diameter=31;
blower_length=5;
bissl=1/100;
$fn=64;
module blade() {
  linear_extrude(height=blade_height) difference() {
  offset(r=wall)blade_profile();
  blade_profile();
  translate([blade_protrusion,-blade_diameter/2])square([blade_diameter,blade_diameter]);
  }
  translate([0,0,blade_height])difference() {
  linear_extrude(height=wall+blade_diameter/2,scale=0)offset(r=wall)blade_profile();
  translate([0,0,-bissl])linear_extrude(height=blade_diameter/2,scale=0)blade_profile();
  translate([blade_protrusion,-blade_diameter/2,-bissl])cube([blade_diameter,blade_diameter,blade_diameter]);
  }
}
module blade_profile() {
  hull() {
    circle(d=blade_diameter);
    translate([blade_protrusion,0]) circle(d=blade_thickness);
  }
  *for (i=[0:0.01:1])
  translate([(1-i)*blade_protrusion,0]) square (center=true,[0.01*blade_protrusion,blade_thickness+(i^blade_curvature)*(blade_diameter-blade_thickness)]);
}
module base() {
*  linear_extrude(height=wall) difference() {
    hull(){
      rotate([0,0,angle])translate([-blade_protrusion-offset/2,0])circle(d=blade_diameter+2*wall);
      rotate([0,0,180-angle])translate([-blade_protrusion-offset/2,0])circle(d=blade_diameter+2*wall);
      rotate([0,0,angle])translate([-offset/2,0])circle(d=blade_thickness+2*wall);
      rotate([0,0,180-angle])translate([-offset/2,0])circle(d=blade_thickness+2*wall);
    }
    rotate([0,0,angle])translate([-blade_protrusion-offset/2,0])circle(d=blade_diameter);
    rotate([0,0,180-angle])translate([-blade_protrusion-offset/2,0])circle(d=blade_diameter);
  }
  difference() {
    hull() {
      rotate([0,0,angle])translate([-blade_protrusion-offset/2,0,0])cylinder(d=blade_diameter+2*wall,h=bissl);
      translate([0,-(blade_protrusion+offset/2)*sin(angle),-blade_protrusion-offset/2])cylinder(d=blower_diameter+2*wall,h=bissl);
      rotate([0,0,180-angle])translate([-blade_protrusion-offset/2,0,0])cylinder(d=blade_diameter+2*wall,h=bissl);
      rotate([0,0,angle])translate([-offset/2,0])cylinder(d=blade_thickness+2*wall,h=bissl);
      rotate([0,0,180-angle])translate([-offset/2,0])cylinder(d=blade_thickness+2*wall,h=bissl);
    }
    hull() {
      rotate([0,0,angle])translate([-blade_protrusion-offset/2,0,bissl])cylinder(d=blade_diameter,h=bissl);
      translate([0,-(blade_protrusion+offset/2)*sin(angle),-blade_protrusion-offset/2-bissl])cylinder(d=blower_diameter,h=bissl);
    }
    hull() {
      rotate([0,0,180-angle])translate([-blade_protrusion-offset/2,0,bissl])cylinder(d=blade_diameter,h=bissl);
      translate([0,-(blade_protrusion+offset/2)*sin(angle),-blade_protrusion-offset/2-bissl])cylinder(d=blower_diameter,h=bissl);
    }
  }
}
module connecting_tube() {
  translate([0,-(blade_protrusion+offset/2)*sin(angle),-blade_protrusion-offset/2-blower_length]) difference() {
    cylinder(d=blower_diameter+2*wall,h=blower_length);
    translate([0,0,-bissl])cylinder(d=blower_diameter,h=2*bissl+blower_length);
  }
}
base();
rotate([0,0,angle])translate([-blade_protrusion-offset/2,0,0])blade();
rotate([0,0,180-angle])translate([-blade_protrusion-offset/2,0,0])blade();
connecting_tube();
