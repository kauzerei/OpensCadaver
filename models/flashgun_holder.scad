//Clamp that can hold a flashgun sideways, a filter in front of that flashgun and can be mounted on a camera nearer to the lens than normally.
//Can be used in macro photography
//Can be used as a part of a cross-polarized setup for photogrammetry

$fs=1/1;
$fa=1/1;
bissl=1/100;

part="all";//[filter_holder,clamp,arm,holder_plate,spacer,all]

flash_width=76;
flash_height=49;
clamp_depth=10;
wall=1.6;
filter_thickness=1;

air=5;

arm_thickness=10;
arm_width=25;
arm_length=150;

bolt=4;
insert=6;
tripod_screw=25.4/4;

window_border=3;
window_width=flash_width+2*window_border;
window_height=flash_height+2*window_border;

filter_border=3;
filter_width=window_width+2*filter_border;
filter_height=window_height+2*filter_border;

holder_border=wall;
holder_height=filter_height+2*holder_border;
holder_width=filter_width+2*holder_border;
holder_depth=2*wall+filter_thickness;
holder_length=30;//holder_height;

clamp_thickness=(holder_height-flash_height)/2;
    
module holder_plate() {
  difference() {
    cube([holder_height,holder_length,arm_thickness]); //mount plate
    for (tr=[
      [clamp_thickness/2,holder_length-clamp_depth/2,-bissl],
      [holder_height-clamp_thickness/2,holder_length-clamp_depth/2,-bissl],
      [holder_height/2,holder_length/2,-bissl]
      ]) translate(tr) cylinder(d=bolt, h=arm_thickness+2*bissl);
    for (tr=[
      [clamp_thickness/2,-bissl,arm_thickness/2],
      [holder_height-clamp_thickness/2,-bissl,arm_thickness/2]
      ]) translate(tr) rotate([-90,0,0])cylinder(d=bolt, h=arm_thickness+2*bissl);
  }
}

module filter_holder() {
  difference() {
    cube([holder_height,holder_width+arm_thickness*2,filter_thickness+wall]);
    translate([holder_border,holder_border+arm_thickness,wall])cube([filter_height,filter_width,filter_thickness+bissl]);
    translate([filter_border+holder_border,holder_border+filter_border+arm_thickness,-bissl]) cube([window_height,window_width,wall+2*bissl]);
    for (tr=[
            [clamp_thickness/2,arm_thickness/2,-bissl],
            [holder_height-clamp_thickness/2,arm_thickness/2,-bissl],
            [clamp_thickness/2,1.5*arm_thickness+holder_width,-bissl],
            [holder_height-clamp_thickness/2,1.5*arm_thickness+holder_width,-bissl]]) 
              translate(tr) cylinder(h=filter_thickness+wall+2*bissl,d=bolt);
  }
}

module clamp() {
  difference() {
    cube([holder_height,holder_width,clamp_depth]);
    translate([clamp_thickness,clamp_thickness,-bissl]) cube([flash_height,flash_width,clamp_depth+2*bissl]);
    for (tr=[
            [clamp_thickness/2,-bissl,clamp_depth/2],
            [holder_height-clamp_thickness/2,-bissl,clamp_depth/2]
      ]) translate(tr) rotate([-90,0,0]) cylinder (d=bolt,h=holder_width+2*bissl);
    translate([-bissl,holder_width/2-air/2,-bissl])cube([holder_height+2*bissl,air,clamp_depth+2*bissl]);
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

module assembly() { //for visualization only
  holder_plate();
  translate([0,-air,0]) rotate([90,0,0])filter_holder();
  translate([0,-2*air-2*wall-2*filter_thickness,0]) rotate([90,0,0]) mirror([0,0,1]) filter_holder();
  translate([0,holder_length,arm_thickness+air])rotate([90,0,0])clamp();
}

if (part=="filter_holder") filter_holder();
if (part=="clamp") clamp();
if (part=="arm") arm();
if (part=="holder_plate") holder_plate();
if (part=="spacer") holder_spacer();
if (part=="all") {
  assembly();
  translate([arm_length*sqrt(2),0,0])assembly();
  spacer();
  translate([holder_height/2,holder_length/2,-bissl])rotate([0,0,45])translate([0,0,-arm_thickness-air])arm();
  translate([arm_length*sqrt(2)+holder_height/2,holder_length/2,-bissl])rotate([0,0,45])translate([0,0,-arm_thickness-air])spacer();
  translate([arm_length*sqrt(2)+holder_height/2,holder_length/2,-arm_thickness-air])rotate([0,0,180-45])translate([0,0,-arm_thickness-air])arm();
}