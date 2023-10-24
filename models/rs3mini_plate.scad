// Plate for dji rs3 mini stab
$fn=64;
height=12.4;
height_top=6.4;
width=38;
width_top=29.6;
depth=43.6;
tcx=10;
tcy=1.5;

pin_length=2.5; //1.7 in reality
pin_diameter=4; //3.4 in reality
lock_thickness=2.4;
lock=lock_thickness+pin_diameter/2;
open_thickness=5.6;
open=open_thickness+pin_diameter/2;
lock_end_thickness=5;
lock_end=depth-lock_end_thickness-pin_diameter/2;
lock_start_thickness=14;
lock_start=lock_start_thickness+pin_diameter/2;

bolt_diameter=16;
bolt_head=height-3;
thread_begin=10;
thread_end=depth-thread_begin;
width_bottom=width_top+2*(height-height_top);
module top_view(){
  //square([depth,width]);
  difference() {
  polygon(points=[[tcx,0],[depth-tcx,0],[depth,tcy],[depth,width-tcy],[depth-tcx,width],[tcx,width],[0,width-tcy],[0,tcy]]);
  hull() {
    translate([thread_begin,width/2,0]) circle(d=5);
    translate([thread_end,width/2,0]) circle(d=5);
  }
  }
}
module side_view(){
  square([depth,height]);
}
module rear_view(){
  *square([height,width]);
  polygon([[0,(width-width_bottom)/2],[height-height_top,(width-width_top)/2],[height,(width-width_top)/2],[height,(width+width_top)/2],[height-height_top,(width+width_top)/2],[0,(width+width_bottom)/2]]);
}
module inner_structure(){
  linear_extrude(pin_length) {
    pin_cutout();
    translate([depth,width])rotate(180) pin_cutout();
  }
  hull() {
    translate([thread_begin,width/2,0])cylinder(d=bolt_diameter,h=bolt_head);
    translate([thread_end,width/2,0])cylinder(d=bolt_diameter,h=bolt_head);
  } 
}
module pin_cutout() {
  pinpoints=[[-pin_diameter/2,width-lock],[lock_start-pin_diameter/2,width-open],[lock_start,width-open],[lock_start,width-lock],[lock_end,width-lock],[lock_end,width-open],[-pin_diameter/2,width-open]];
  for (i=[0:1:5]) hull() {
    translate(pinpoints[i]) circle(d=pin_diameter);
    translate(pinpoints[i+1]) circle(d=pin_diameter);
  }
    
}
difference() {
  intersection() {
    linear_extrude(height,convexity=2) top_view();
    rotate([-90,0,0]) mirror([0,1,0]) linear_extrude(width,convexity=2) side_view();
    rotate([0,90,0]) mirror([1,0,0]) linear_extrude(depth,convexity=2) rear_view();
  }
  inner_structure();
}