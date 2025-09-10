//Aligner or cradle for Pixel 7 to be placed on Ikea's wireless charger.

/* Printables/Thingiverse description
Google Pixel 7 wireless charging cradle for Ikea LIVBOJ 

Fits around Ikea wireless charger LIVBOJ.
Designed for Google Pixel 7 (just 7, not A, not Pro) without any case.
It's parametric and written in OpenSCAD, so it can be enlarged to fit the case if needed.
Doesn't center the phone perfectly: because of the stupid camera bump, it's 4mm off, but it's more than precise enough.
There are two versions of cable alignment: towards the charging port of the phone and towards the right side.
You can also print it facing the left side by mirroring in the slicer.

Heavily inspired by https://www.printables.com/model/450027-phone-cradle-for-pixel-7-and-ikea-nordmarke-qi-cha
although it's not a remix, but a complete rewrite from scratch.

My github repo for all of my models may contain a newer version of this model: https://github.com/kauzerei/OpensCadaver/blob/main/models/pixel7_charger_aligner.scad
*/

include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fa=1/2;
$fs=1/2;
bsl=1/100;

part="side_cut";//[side_cut,end_cut]
cutout_width=14;

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
charger_s=-4;
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
  translate([0,charger_s,0])cylinder(d=charger_d+2*beam_width,h=charger_h-camera_protrusion);
  }
  translate([0,charger_s,-bsl]) cylinder(d=charger_d,h=charger_h+2*bsl);
  if (part=="side_cut") translate([0,charger_s-cutout_width/2,-bsl]) cube([charger_d,cutout_width,charger_h-camera_protrusion+2*bsl]);
  if (part=="end_cut") translate([-cutout_width/2,-charger_d,-bsl]) cube([cutout_width,charger_d,charger_h-camera_protrusion+2*bsl]);
}