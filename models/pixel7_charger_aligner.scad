//An aligner to be placed on Ikea's wireless charger.
//Doesn't centers Google Pixel 7 perfectly, because of the stupid camera bump
//It's 4mm off and I hate it, but it's the best one can do

include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fa=1/2;
$fs=1/2;
bsl=1/100;

phone_width=73;
phone_height=155;
edge_radius=6;

wall_width=4;
wall_height=5;
beam_width=8;
edge_size=14;
beam_pos=0;

charger_d=91;
charger_h=10;
camera_protrusion=4;

function phone()=subdivide_path(rect([phone_width,phone_height],rounding=edge_radius),maxlen=1);

function holder_crossection()=round_corners(
  round_corners(
    [[0,charger_h],
     [0,charger_h+wall_height],
     [wall_width,charger_h+wall_height],
     [wall_width,0],
     [-wall_width,0],
     [-wall_width,charger_h]],
    cut=[0,1,1,1,1,0.5],
    method="chamfer"),
   cut=[1,0,0,0,0,0,0,0,0,0,0]);
 
 module corner() {
  edge=[for (i=phone()) each norm(i-[phone_width/2,phone_height/2])<edge_size?[i]:[] ];
  path_sweep(holder_crossection(),edge,closed=false,caps=1,$fn=4);
}

module beam_structure() {
  hull() {
    translate([phone_width/2,phone_height/2]) circle(d=beam_width);
    translate([0,beam_pos]) circle(d=beam_width);
  }
  hull() {
    translate([-phone_width/2,phone_height/2]) circle(d=beam_width);
    translate([0,beam_pos]) circle(d=beam_width);
  }
  hull() {
    translate([phone_width/2,-phone_height/2]) circle(d=beam_width);
    translate([0,-beam_pos]) circle(d=beam_width);
  }
  hull() {
    translate([-phone_width/2,-phone_height/2]) circle(d=beam_width);
    translate([0,-beam_pos]) circle(d=beam_width);
  }
}
  
difference() {
  union() {
    for (m1=[[0,0,0],[1,0,0]]) for (m2=[[0,0,0],[0,1,0]]) mirror(m1) mirror(m2) corner();
    intersection ()  {
      linear_extrude(height=30,convexity=2) beam_structure();
      linear_extrude(height=charger_h-camera_protrusion) polygon(phone());
    }
  translate([0,-4,0])cylinder(d=charger_d+2*beam_width,h=charger_h-camera_protrusion);
  }
  translate([0,-4,-bsl]) cylinder(d=charger_d,h=charger_h+2*bsl);
  //rotate([90,0,0]) cylinder(d=14,h=2*phone_height);
  translate([-7,-phone_height,-bsl]) cube([14,phone_height,charger_h-camera_protrusion+2*bsl]);
}