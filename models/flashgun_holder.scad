//Clamp that can hold a flashgun sideways, a filter in front of that flashgun and can be mounted on a camera nearer to the lens than normally.
//Can be used in macro photography
//Can be used as a part of a cross-polarized setup for photogrammetry

$fs=1/1;
$fa=1/2;
bissl=1/100;

part="NOSTL_all";//[filter_holder,clamp,arm,holder_plate,spacer,thumb_screw_small,thumb_screw_big,NOSTL_all]

flash_width=76;
flash_height=49;
clamp_depth=10;
wall=1.6;
filter_thickness=1.6;

air=5;

arm_thickness=10;
arm_width=25;
arm_length=200;

bolt=4;
insert=6;
tripod_screw=7;
tripod_hex=14;
nut_d=9;

//flash defines clamp, clamp defines filter, filter defines window

holder_border=wall;
clamp_thickness=10;
clamp_height=flash_height+2*clamp_thickness;
clamp_width=flash_width+2*clamp_thickness;
holder_depth=2*wall+filter_thickness;
holder_length=30;//distance from clamp to filter

filter_border=3;
filter_width=clamp_width-2*wall;
filter_height=clamp_height-2*wall;

window_width=filter_width-2*filter_border;
window_height=filter_height-2*filter_border;

//threaded_insert=6;

module hole(bolt_d=bolt, nut_d=nut_d, wall = wall, depth = depth, bissl=1/100, alot=200) {
  translate([ 0, 0, -bissl ]) cylinder(d = bolt_d, h = alot);
  if (is_undef(threaded_insert)) translate([ 0, 0, -bissl ]) cylinder(d = nut_d, h = wall - depth, $fn = 6);
  if (!is_undef(threaded_insert)) translate([ 0, 0, -bissl ]) cylinder(d = threaded_insert, h = alot);
}

module holder_plate() {
  difference() {
    cube([clamp_height,holder_length,arm_thickness]); //mount plate
    for (tr=[
      [clamp_thickness/2,holder_length-clamp_depth/2,0],
      [clamp_height-clamp_thickness/2,holder_length-clamp_depth/2,0],
      ]) translate(tr) hole(bolt_d=bolt, nut_d=nut_d, wall = clamp_depth, depth = 2);
    translate([clamp_height/2,holder_length/2,arm_thickness]) mirror([0,0,1]) hole(bolt_d=bolt, nut_d=nut_d, wall = clamp_depth, depth = 2);
      
    for (tr=[
      [clamp_thickness/2,-bissl,arm_thickness/2],
      [clamp_height-clamp_thickness/2,-bissl,arm_thickness/2]
      ]) translate(tr) rotate([-90,0,0])cylinder(d=bolt, h=arm_thickness+2*bissl);
  }
}

module filter_holder() {
  difference() {
    cube([clamp_height,holder_depth,clamp_width+arm_thickness*2]);
    translate([(clamp_height-window_height)/2,-bissl,filter_border+arm_thickness]) cube([window_height,holder_depth+2*bissl,window_width]);
    translate([holder_border,wall,holder_border+arm_thickness])cube([filter_height,filter_thickness,filter_width+arm_thickness+holder_border+bissl]);
    for (tr=[
            [clamp_thickness/2,-bissl,arm_thickness/2],
            [clamp_height-clamp_thickness/2,-bissl,arm_thickness/2],
            ]) translate(tr) rotate([-90,0,0])cylinder(h=filter_thickness+2*wall+2*bissl,d=bolt);
    /*
    translate([holder_border,holder_border+arm_thickness,wall])cube([filter_height,filter_width,filter_thickness+bissl]);
    translate([filter_border+holder_border,holder_border+filter_border+arm_thickness,-bissl]) cube([window_height,window_width,wall+2*bissl]);
    for (tr=[
            [clamp_thickness/2,arm_thickness/2,-bissl],
            [holder_height-clamp_thickness/2,arm_thickness/2,-bissl],
            [clamp_thickness/2,1.5*arm_thickness+holder_width,-bissl],
            [holder_height-clamp_thickness/2,1.5*arm_thickness+holder_width,-bissl]]) 
              translate(tr) cylinder(h=filter_thickness+wall+2*bissl,d=bolt);
              */
  }
}

module clamp() {
  difference() {
    cube([clamp_height,clamp_width,clamp_depth]);
    translate([clamp_thickness,clamp_thickness,-bissl]) cube([flash_height,flash_width,clamp_depth+2*bissl]);
    for (tr=[
            [clamp_thickness/2,-bissl,clamp_depth/2],
            [clamp_height-clamp_thickness/2,-bissl,clamp_depth/2]
      ]) translate(tr) rotate([-90,0,0]) cylinder (d=bolt,h=clamp_width+2*bissl);
    translate([-bissl,clamp_width/2-air/2,-bissl])cube([clamp_height+2*bissl,air,clamp_depth+2*bissl]);
  }
}

module arm() {
  difference() {
    hull() {
      cylinder(d=arm_width,h=arm_thickness);
      translate([arm_length,0,0])cylinder(d=arm_width,h=arm_thickness);
    }
    translate([0,0,-bissl])cylinder(d=bolt,h=arm_thickness+2*bissl);
    translate([arm_length,0,-bissl])cylinder(d=tripod_screw,h=arm_thickness+2*bissl);
  }
}

module spacer() {
  difference() {
    cylinder(d=arm_width,h=arm_thickness);
    translate([0,0,-bissl]) cylinder(d=tripod_screw,h=arm_thickness+2*bissl);
  }
}

module thumb_screw(bolt_d,hex_d,wall=3,angle=45,flap_d,flap_l,flap_h){
  flap_d=is_undef(flap_d)?hex_d/2+wall:flap_d;
  flap_l=is_undef(flap_l)?hex_d+2*wall:flap_l;
  flap_h=is_undef(flap_h)?hex_d+2*wall:flap_h;
  cyl_d=hex_d+2*wall;
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

module assembly() { //for visualization only
  holder_plate();
  translate([clamp_height/2,holder_length/2,-2*arm_thickness-3*air]) mirror([0,0,1]) thumb_screw(bolt_d=bolt,hex_d=nut_d,wall=wall);
  translate([0,-air-filter_thickness-2*wall,0]) filter_holder();
  *translate([0,-2*air-2*wall-2*filter_thickness,0]) rotate([90,0,0]) mirror([0,0,1]) filter_holder();
  translate([0,holder_length,arm_thickness+air])rotate([90,0,0])clamp();
  translate([clamp_thickness/2,holder_length-clamp_depth/2,clamp_width+arm_thickness+2*air])thumb_screw(bolt_d=bolt,hex_d=nut_d,wall=wall);
  translate([clamp_height-clamp_thickness/2,holder_length-clamp_depth/2,clamp_width+arm_thickness+2*air])thumb_screw(bolt_d=bolt,hex_d=nut_d,wall=wall);
}

if (part=="filter_holder") filter_holder();
if (part=="clamp") clamp();
if (part=="arm") arm();
if (part=="holder_plate") holder_plate();
if (part=="spacer") spacer();
if (part=="thumb_screw_small") thumb_screw(bolt_d=bolt,hex_d=nut_d,wall=wall);
if (part=="thumb_screw_big") thumb_screw(bolt_d=tripod_screw,hex_d=tripod_hex,wall=wall);
if (part=="NOSTL_all") {
  assembly();
  translate([arm_length/sqrt(2)+clamp_height/2,arm_length/sqrt(2)+holder_length/2,-2*arm_thickness-3*air])mirror([0,0,1])thumb_screw(bolt_d=tripod_screw,hex_d=tripod_hex,wall=wall);
  translate([arm_length*sqrt(2),0,0])assembly();
  translate([clamp_height/2,holder_length/2,-bissl])rotate([0,0,45])translate([0,0,-arm_thickness-air])arm();
  translate([arm_length*sqrt(2)+clamp_height/2,holder_length/2,-bissl])rotate([0,0,45])translate([0,0,-arm_thickness-air])spacer();
  translate([arm_length*sqrt(2)+clamp_height/2,holder_length/2,-arm_thickness-air])rotate([0,0,180-45])translate([0,0,-arm_thickness-air])arm();
}