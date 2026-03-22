include <../import/BOSL2/std.scad>
$fs=1/4;
$fa=1/4;
bsl=1/100;

radius=350;
length=80;
width=4;
thickness=4;
chamfer=1;
round=1;
tab_width=4;
tab_length=20;
tab_diameter=10;
text=0.4;
dist=2;

module bow(r,w,l) {
  intersection() {
    difference(){
      translate([-r,0]) circle(r=r);
      translate([-r-w,0]) circle(r=r);
    }
    square([r,l],center=true);
  }
  difference() {
    for (m=[0,1]) mirror([0,m]) translate([sqrt(r^2-(l/2)^2)-r-w/2,l/2]) circle(d=w);
    square([r,l],center=true);
  }
}

module profile(radius) {
  bow(radius,width,length);
  translate([-width/2,-tab_width/2])square([tab_length+width/2+tab_diameter/2,tab_width]);
  translate([tab_length+tab_diameter/2,0]) circle(d=tab_diameter);
}

module drafted_extrude(height,angle) {
  intersection_for(a=[360/32:360/32:360]) linear_extrude(height=height/cos(angle),v=[cos(a),sin(a),tan(angle)],convexity=4) {
    children();
  }
}

module chamfered_extrude(height,chamfer) {
  linear_extrude(height=height-2*chamfer,center=true) children();
  for (m=[0,1]) mirror([0,0,m]) translate([0,0,height/2-chamfer]) {
    drafted_extrude(height=chamfer,angle=45) children();
  }
}

module gauge(radius) {
  difference() {
    chamfered_extrude(thickness,chamfer) {
      difference() {
        profile(radius);
        translate([-chamfer,-tab_width/2]) square([tab_length+2*chamfer,width]);
      }
      offset(r=-round)
      offset(r=round)
      intersection() {
        profile(radius);
        translate([-chamfer,-tab_width/2-chamfer]) square([tab_length+2*chamfer,width+2*chamfer]);
      }
    }
    translate([tab_length+tab_diameter/2,0,-thickness/2+text]) rotate([180,0,0]) linear_extrude(text) {
      text(text=str(round(radius/25.4)),halign="center",valign="center",size=tab_diameter/3);
    }
  }
  linear_extrude(thickness/2+text) translate([tab_length+tab_diameter/2,0]) {
    text(text=str(radius),halign="center",valign="center",size=tab_diameter/4);
  }
}

gauge(radius);