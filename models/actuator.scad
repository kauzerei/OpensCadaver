// Magnetic actuator draft
// Developed for acoustic drum hitting machine

/*
use <../import/threads.scad>;
$fs=1/1;
$fa=1/2;
bissl=1/100;

part="assembly"; //[plunger_it, plunger_ot, spool, spool_no_cap, spoolcap]
air=1.0;
magnet_d=10;
magnet_h=2;
thread_pitch=3;
thread_add=2*thread_pitch*cos(30);
threads=2;
wall=1.6;
plunger_height=30;
spool_thickness=5;
stopper=5;
throw=15;

d1 = magnet_d + thread_add; //outer smaller thread
d2 = d1 + 2*air; //inner bigger thread
d3 = d2 + 2*wall; //outer plunger shell
d4 = d3 + 2*air; //inner spool shell
d5 = d4 + 2*wall; //outer spool shell

module plunger_half(inner_thread=false) {
  difference() {
    union() {
      cylinder( d = d3 + 2*stopper, h = wall );
      translate( [0, 0, wall] ) cylinder( d = d3, h = plunger_height/2 );
      if( !inner_thread ) translate( [0, 0, wall + plunger_height/2] ) ScrewThread( outer_diam = d1, pitch = thread_pitch, height = threads*thread_pitch - magnet_h );
    }
    if ( inner_thread ) translate( [0, 0, wall + plunger_height/2 - threads*thread_pitch] ) ScrewThread( outer_diam = d2, pitch = thread_pitch, height = threads*thread_pitch + bissl );
  }
}

module spool( length, topcap = true ) {
  difference() {
    union() {
      cylinder( d = d5 + 2*spool_thickness, h = wall );
      translate( [0, 0, wall] ) cylinder( d = d5, h = length );
      if( topcap ) translate( [0, 0, wall + length] ) cylinder( d = d5 + 2*spool_thickness, h=wall );
    }
    translate( [0, 0, -bissl] ) cylinder( d = d4, h = length + 2*wall + 2*bissl );
  }
}
if ( part == "plunger_it" ) plunger_half( inner_thread = true );
if ( part == "plunger_ot" ) plunger_half();
if ( part == "spool" ) spool( plunger_height - throw - 2*wall );
if ( part == "spool_no_cap" ) spool( plunger_height - throw - 2*wall, topcap = false );
if ( part == "spoolcap" ) difference() {
  cylinder( d = magnet_d + thread_add + 2*air + 2*wall + 2*air + 2*wall + spool_thickness, h = wall, center = true );
  cylinder( d = magnet_d + thread_add + 2*air + 2*wall + 2*air, h = wall + bissl, center = true ); 
  }
if ( part == "assembly" ) {
  plunger_half( inner_thread = true );
  translate( [0, 0, plunger_height + 2*wall] ) rotate( [180, 0, 0] ) plunger_half();
  translate( [0, 0, wall + air] ) spool( plunger_height - throw - 2*wall );
}

*/

$fs=1/1;
$fa=1/2;

wall=0.8;
air=0.5;
m_d=10;
m_h=2;
p_id=m_d+2*air;
p_od=p_id+2*wall;
p_h=20;
s_id=p_od+2*air;
s_od=s_id+2*wall;
s_h=10;
border=3;
bissl=1/100;
*difference() {
  cylinder(d=p_od,h=p_h);
  translate([0,0,(p_h-m_h)/2]) cylinder(d=p_id,h=p_h);
}

*difference() {
  union() {
    cylinder(d=s_od,h=s_h);
    cylinder(d=s_od+2*border, h=wall);
    translate([0,0,s_h-border])cylinder(d2=s_od+2*border, d1=s_od, h=border);
  }
  translate([0,0,-bissl])cylinder(d=s_id,h=s_h+2*bissl);
  translate([0,0,s_h-border-bissl])cylinder(d2=s_id+2*border, d1=s_id, h=border+2*bissl);
}

module coil_spool(id,wall,height,border,extra) {
  difference() {
    union() {
      cylinder(d=id+2*wall,h=height+extra);
      cylinder(d=id+2*border+2*wall, h=wall);
      
    }
    translate([0,0,-bissl])cylinder(d=id,h=height+extra+2*bissl);
  }
  difference() {
    translate([0,0,height-border])cylinder(d2=id+2*border+2*wall, d1=id+2*wall, h=border);
    translate([0,0,height-border-bissl])cylinder(d2=id+2*border, d1=id, h=border+2*bissl);
  }
}
coil_spool(id=5,wall=0.8,height=30,border=5,extra=20);