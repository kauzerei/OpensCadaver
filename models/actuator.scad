// Magnetic actuator draft
// Developed for acoustic drum hitting machine

use <../import/threads.scad>;
$fs=1/1;
$fa=1/2;
bissl=1/100;

part="assembly"; //[plunger_it, plunger_ot, spool, spool_no_cap, spoolcap]
air=0.5;
magnet_d=10;
magnet_h=2;
thread_pitch=3;
thread_add=2*thread_pitch*cos(30);
threads=2;
wall=1.6;
plunger_height=30;
spool_thickness=10;
stopper=5;
throw=15;

module plunger_half(inner_thread=false) {
  difference() {
    union() {
      cylinder( d=magnet_d + thread_add + 2*air + 2*wall + 2*stopper, h = wall );
      translate( [0, 0, wall] ) cylinder( d = magnet_d + thread_add + 2*air + 2*wall, h = plunger_height/2 );
      if( !inner_thread ) translate( [0, 0, wall + plunger_height/2] ) ScrewThread( outer_diam = magnet_d + thread_add, pitch = thread_pitch, height = threads*thread_pitch - magnet_h );
    }
    if ( inner_thread ) translate( [0, 0, wall + plunger_height/2 - threads*thread_pitch] ) ScrewThread( outer_diam = magnet_d + thread_add + 2*air, pitch = thread_pitch, height = threads*thread_pitch + bissl );
  }
}

module spool( length, topcap = true ) {
  difference() {
    union() {
      cylinder( d = magnet_d + thread_add + 2*air + 2*wall + 2*air + 2*wall + spool_thickness, h = wall );
      translate( [0, 0, wall] ) cylinder( d = magnet_d + thread_add + 2*air + 2*wall + 2*air + 2*wall, h = length );
      if( topcap ) translate( [0, 0, wall + length] ) cylinder( d = magnet_d + thread_add + 2*air + 2*wall + 2*air + 2*wall + spool_thickness, h=wall );
    }
    translate( [0, 0, -bissl] ) cylinder( d = magnet_d + thread_add + 2*air + 2*wall + 2*air, h = length + 2*wall + 2*bissl );
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