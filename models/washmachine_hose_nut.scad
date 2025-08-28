// Contraption to hold the washing machine hose in place.
// Probably specific to my hardware.
// Consists of two parts because it's impossible to put a tightening nut onto an existing assembled hose.
// The threaded part is wide enough to pass the wide part of the hose through.
// Then the wedging part is inserted into it and the whole thing holds both the hose widening and the thread in the wall. 

include <../import/BOSL2/std.scad>
include <../import/BOSL2/threading.scad>

part="NOSTL_all";//[insert,threaded,NOSTL_all,print_together]
insert="cutaway";//[cutaway,divided]
cutaway_angle=45;

thread_d=33;
thread_pitch=2.3;
thread_h=25;

insert_h=5;
insert_bd=33;
insert_sd=30;
hose_d=26;

nut_od=38;
slack=1;

$fs=1/2;
$fa=1/2;
bsl=1/100;

module insert_divided() {
  difference() {
    cylinder(d1=insert_bd-slack,d2=insert_sd-slack,h=insert_h);
    translate([0,0,-bsl]) cylinder(d=hose_d,h=insert_h+2*bsl);
    cube([slack,1.1*insert_bd,2.1*insert_h],center=true);
    cube([1.1*insert_bd,slack,2.1*insert_h],center=true);
  }
}

module insert_cutaway() {
  difference() {
    cylinder(d1=insert_bd-slack,d2=insert_sd-slack,h=insert_h);
    translate([0,0,-bsl]) cylinder(d=hose_d,h=insert_h+2*bsl);
    translate([0,0,-bsl]) linear_extrude(h=insert_h+2*bsl) {
      arc(n=cutaway_angle, r=insert_bd, angle=cutaway_angle, wedge=true);
    }
  }
}

module insert() {
  if (insert=="divided") insert_divided();
  if (insert=="cutaway") insert_cutaway();
}

module nut() {
  difference () {
    cyl(d=nut_od,h=insert_h+thread_h,anchor=BOT,texture="ribs",tex_taper=0,tex_depth=0.7,tex_size=2);
    translate([0,0,-bsl]) cylinder(d1=insert_sd,d2=insert_bd,h=insert_h+2*bsl);
    translate([0,0,insert_h]) threaded_rod(d=thread_d, height=thread_h+bsl, pitch=thread_pitch,internal=true,anchor=BOT, $fa=$fa, $fs=$fs);
  }
}

if (part=="insert") insert();
if (part=="threaded") nut();
if (part=="NOSTL_all") {
  translate([0,0,insert_h-bsl]) rotate([180,0,0,]) insert();
  nut();
}
if (part=="print_together") {
  translate([nut_od,0,0]) insert();
  nut();
}