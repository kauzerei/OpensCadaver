/*
Screw heads for making nice thumb screws from regular hex screws
Projects: camera stab, cross-polarized flashes setup
1/4 inch jam nut that fixes the screwed-on sled in arbitrary orientation 
*/
$fs=1/2;
$fa=1/1;
bissl=1/100;
h=5.5;
wall=3;
id=8; //screw diameter
hex=13; //point-to-point measurement of hex screw head
handle=36;
n=6;

max_angle=45; //maximal printable angle without supports, inclination of flaps walls 

part="thumb_screw";//[thumb_screw,jam_screw]

module jam_nut() {
  difference() {
    handle(d=handle,h=h+wall,n=n);
    cylinder(d=id,h=h+wall+bissl);
    translate([0,0,wall])cylinder($fn=6,d=hex,h=h+bissl);
  }
}

module handle(d,n,h) {
  difference() {
    union() {
      cylinder(d=d,h=h,$fn=2*n);
      for (i=[0:360/n:360]) {
        rotate([0,0,i])translate([d/2,0,0])cylinder(d=d*sin(90/n),h=h);
      }
    }
    for (i=[0:360/n:360]) {
      rotate([0,0,i+180/n])translate([d/2,0,-0.01])cylinder(d=d*sin(90/n),h=h+0.02);
    }
  }
}

module thumb_screw() {
  cyl_d=hex+2*wall;
  flap_d=cyl_d/2; //thickness of side flaps, can be overriden
  flap_len=cyl_d;
  flap_height=cyl_d;
  h=((flap_len-cyl_d/2-flap_d/2)+(flap_d/2)/cos(max_angle))/tan(max_angle);
  difference() {
    hull() {
      //cylinder(d=cyl_d,h=2*h+flap_height-flap_d);
      cylinder(d=cyl_d,h=h);
      rotate_extrude(angle=360,convexity=1) {
        translate([cyl_d/2-wall,2*h+flap_height-flap_d-wall])circle(r=wall);
      }
      for (tr=[
      [-flap_len+flap_d/2,0,h],
      [flap_len-flap_d/2,0,h],
      [-flap_len+flap_d/2,0,h+flap_height-flap_d],
      [flap_len-flap_d/2,0,h+flap_height-flap_d],
      ]) translate(tr) sphere (d=flap_d);
    }
    translate([0,0,-bissl])cylinder(d=id,h=100);
    translate([0,0,wall])cylinder(d=hex,h=100,$fn=6);
  }
}

module thumb_screw_parametric(bolt_d,hex_d,wall=3,angle=45,flap_d,flap_l,flap_h){
  flap_d=is_undef(flap_d)?hex_d/2+wall:flap_d;
  flap_l=is_undef(flap_l)?hex_d+2*wall:flap_l;
  flap_h=is_undef(flap_h)?hex_d+2*wall:flap_h;
  cyl_d=hex+2*wall;
  h=((flap_l-cyl_d/2-flap_d/2)+(flap_d/2)/cos(angle))/tan(angle);
  difference() {
    hull() {
      cylinder(d=cyl_d,h=h);
      rotate_extrude(angle=360,convexity=1) translate([cyl_d/2-wall,2*h+flap_h-flap_d-wall])circle(r=wall);
      for (tr=[
        [-flap_l+flap_d/2,0,h],
        [flap_l-flap_d/2,0,h],
        [-flap_l+flap_d/2,0,h+flap_h-flap_d],
        [flap_l-flap_d/2,0,h+flap_h-flap_d],
      ]) translate(tr) sphere (d=flap_d);
    }
    translate([0,0,-bissl])cylinder(d=bolt_d,h=100);
    translate([0,0,wall])cylinder(d=hex_d,h=100,$fn=6);
  }
}
if (part=="thumb_screw") thumb_screw_parametric(bolt_d=8,hex_d=13);
if (part=="jam_screw") jam_screw();