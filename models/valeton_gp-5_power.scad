//Rechargable battery pack for Valeton GP-5
//Uses cheap charge+boost module with street lithium cells.

include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;

part="box";//[box,cap,NOSTL_assembly]

wall=0.8;
width=38;
length=40; 
height=31; //pedal height without cap
round=6; //rounding radius of original pedal
ear_offset=5;
ear_d=7; //holds bottom screw
hole=4; //bottom screw
lip=2; //protruding features like on cap and ones holding the pcb
a=2; //draft angle

pcb_h1=2; //pcb heights on the left side
pcb_h2=5; //and the right side
pcb_l=33.5; 
pcb_w=23;
pcb_offset=1; //from origin plane, tuned by hand
charger=[8,3]; //charger hole size
charger_offset=[9.5,2.5]; //to pcb origin

jack_h=18; //vertical position of jack
jack_o=2; //horizontal offset
jack_depth=2; //outer collar recess
jack_hole=8.5; //outer colar diameter
jack_wall=2; //wall thickness that holds the jack
jack_thread=7.5; //diameter of "threaded" part
thread_depth=5; //length of "threaded" part

sw_dist=15; //distance between switch mounting points
sw_depth=3; //distance between mounting surcace and inner enclosure surface
sw_rect=[7,3.5]; //cutout for slider
sw_hole=3.5; //mounting hole diameter
sw_width=20; //larger length of mounting surface
sw_offset=-8; //horizontal offset from center

cm_depth=3; //depth of non-chamfered part of cover mount feature
cm_hole=3; //diameter of cover mounting hole
cm_width=6; //side of square cross section of cover mount feature
gap=0.5; //slack between cover lip and inner enclosure surface

mnt1=[[-wall,0],[0,0],[0,pcb_h1],[lip,pcb_h1],[lip,pcb_h1+wall],[-wall,pcb_h1+wall]];
mnt2=[[0,0],[wall,0],[wall,pcb_h2+wall],[-lip,pcb_h2+wall],[-lip,pcb_h2],[0,pcb_h2]];
scale1=[(length+height*tan(a))/length,(width/2-height*tan(a))/(width/2)];
scale2=[(length-2*wall+height*tan(a))/(length-2*wall),(width/2-wall-height*tan(a))/(width/2-wall)];

module footprint() {
rect([length,width],rounding=[round,-round,-round,round],anchor=RIGHT);
}

module outer() {
  translate([length,0,0]) linear_extrude(height=height,scale=scale1, convexity=4) footprint();
}

module inner() {
  translate([length,0,wall]) linear_extrude(height=height,scale=scale2) offset(r=-wall) footprint();
}

module jack_mount(cutout) fwd(jack_o) {
  if (!cutout) left((jack_h+jack_hole/2+jack_wall)*tan(a)) {
    up(jack_h) {
      difference() {
        xcyl(d=jack_hole+jack_wall*2,h=jack_depth+thread_depth,anchor=LEFT);
        left(bsl) xcyl(d=jack_hole,h=jack_depth+bsl,anchor=LEFT);
        right(jack_depth-bsl) xcyl(d=jack_thread,h=thread_depth+2*bsl,anchor=LEFT);
      }
    }
    cube([jack_depth+thread_depth,wall,jack_h-jack_hole/2],anchor=LEFT+BOTTOM);
  }
  else left((jack_h+jack_hole/2+jack_wall)*tan(a)) up(jack_h) {
    left(bsl) xcyl(d=jack_hole,h=jack_depth+bsl,anchor=LEFT);
    right(jack_depth-bsl) xcyl(d=jack_thread,h=thread_depth+2*bsl,anchor=LEFT);
  }
}

module pcb_mount(cutout=false) {
  if (cutout) translate(charger_offset){
    translate([pcb_offset,-width/2+wall,-bsl]) cube([charger[0],charger[1],wall+2*bsl],anchor=BOTTOM);
  }
  else {
    translate([pcb_offset,-width/2+wall,wall]) linear_extrude(height=pcb_w,convexity=4,v=[0,sin(a),cos(a)])  polygon(mnt1);
    translate([pcb_offset+pcb_l,-width/2+wall,wall]) linear_extrude(height=pcb_w,convexity=4,v=[0,sin(a),cos(a)])  polygon(mnt2);
  }
}

module switch_mount(cutout=false) {
  translate([length-wall,sw_offset,height-sw_width/2-lip]) rotate([0,-90,0]) {
    if (cutout) {
      down(wall+bsl)cube([sw_rect[0],sw_rect[1],wall+3*bsl],anchor=BOTTOM);
    }
    else difference() {
      hull() {
        cube([sw_width,hole+2*wall,sw_depth],anchor=BOTTOM);
        scale([1,1,0]) cube([sw_width/2+sw_depth,sw_rect[1]+2*wall,1],anchor=BOTTOM+RIGHT);
      }
    down(bsl)left(sw_dist/2)cylinder(d=sw_hole,h=sw_depth+2*bsl);
    down(bsl)right(sw_dist/2)cylinder(d=sw_hole,h=sw_depth+2*bsl);
    down(bsl)cube([sw_rect[0],sw_rect[1],sw_depth+2*bsl],anchor=BOTTOM);
    }
  }
}

module cover_mount() {
  difference() {
    hull() {
      cube([cm_width,cm_width,cm_depth],anchor=RIGHT+TOP);
      scale([0,1,1]) cube([cm_width,cm_width,cm_depth+cm_width],anchor=RIGHT+TOP);
    }
  left(cm_width/2) down(cm_width+cm_depth) cylinder(d=cm_hole,h=cm_width+cm_depth+bsl);
  }
}

module box() {
  difference() {
    outer();
    difference() {
      inner();
      jack_mount();
      mirror([1,0,0])  right((height-lip)*tan(a)-wall) up(height-lip) cover_mount();
    }
    jack_mount(true);
    pcb_mount(true);
    switch_mount(true);
  }
  //mounting ears
  difference() {
    union() {
      translate([-ear_offset,width/2-ear_offset,0])cylinder(h=wall,d=ear_d);
      translate([-ear_offset,-width/2+ear_offset,0])cylinder(h=wall,d=ear_d);
      translate([-ear_offset,-width/2,0])cube([ear_offset+ear_d/2,ear_offset+ear_d/2,wall]);
      translate([-ear_offset,width/2-ear_offset-ear_d/2,0])cube([ear_offset+ear_d/2,ear_offset+ear_d/2,wall]);
    }
      translate([-ear_offset,width/2-ear_offset,-bsl])cylinder(h=wall+2*bsl,d=hole);
      translate([-ear_offset,-width/2+ear_offset,-bsl])cylinder(h=wall+2*bsl,d=hole);
  }
  pcb_mount();
  switch_mount();
  up(height-lip) right(length-wall) cover_mount();
}

module cover() {
  difference() {
    linear_extrude(height=wall, convexity=4) scale(scale1) footprint();
    left(wall+cm_width/2) down(bsl) cylinder(d=cm_hole,h=wall+2*bsl);
    left(length+(height-lip)*tan(a)-wall-cm_width/2)
    down(bsl) cylinder(d=cm_hole,h=wall+2*bsl);
  }
  up(wall) linear_extrude(height=lip) difference() {
    scale(scale2) offset(r=-wall-gap) footprint();
    offset(r=-wall) scale(scale2) offset(r=-wall-gap) footprint();
  }
}
if(part=="box") box();
if(part=="cap") cover();
if(part=="NOSTL_assembly") {
  box();
  right(length) up(height+wall+lip+1) mirror([0,0,1]) cover();
}