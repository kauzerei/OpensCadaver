$fs=1/1;
$fa=1/1;
bsl=1/100;

part="camera_mount";//[bottom,top,electronics,battery,cover,camera_mount,NOSTL_assembly]

pcb_height=1;
led_height=1;
pcb_size=[30.5,28.4];
dcdc_thickness=8;

slack=0.2;
hook_width=12;
wall=1.2;
vert_wall=1.2;
lip=1;
insert_w=3.2;

n_leds=6;
led_offset=43;
hole_dist=2*led_offset*sin(180/n_leds);

id=45;
od=128;

sw_dist=15; //distance between switch mounting points
sw_depth=3; //distance to mounting surface
sw_rect=[7,3.5]; //cutout for slider
sw_hole=3.5; //mounting hole diameter
sw_wall=1.6; //min distance from any hole to mounting surface side
sw_length=sw_dist+sw_hole+2*sw_wall; //larger length of mounting surface
sw_width=2*sw_wall+max([sw_hole,sw_rect[1]]); //shorter side of mounting surface

bp_length=60;
bp_height=sw_length;
bp_width=(od-id)/2+2*vert_wall;
bp_offset=id/2-vert_wall;

dt_h=2; //total height of dovetatil profile
dt_offset=1; //dovetailness of dovetail, 1mm offset on 1mm half-height is 45 degrees
dt_slack=0.0; //wiggle room in horizontal direction

wire=4; //holes for wires
tweak_wire=3; //manually adjustment for wire position
wire_offset=id/2+wire/2+vert_wall+slack+tweak_wire;
four_wire_offset_tweak=6;
four_wire_offset=bp_length-vert_wall-wire/2-sw_depth-four_wire_offset_tweak;

module hook() { //holds led from one side
  hull() {
    translate([-hook_width/2,0,0]) cube([hook_width,vert_wall,pcb_height+led_height]);
    scale([1,1,0]) translate([-hook_width/2,0,0]) cube([hook_width,vert_wall+pcb_height+led_height,1]);
  }
}

module bottom_holder() { //holds one led from 4 sides
  rot=[0,90,180,270];
  shift=[pcb_size[1]/2,pcb_size[0]/2,pcb_size[1]/2,pcb_size[0]/2];
  for (i=[0:1:3]) rotate([0,0,rot[i]]) translate([0,shift[i]+slack,0]) hook();
}

module bottom() {
  linear_extrude(height=wall) { //ring shaped area, large back surface
    difference() {
      circle(d=od);
      circle(d=id);
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate([0,0,a]) translate([led_offset,0,0]) square(pcb_size-2*[lip,lip],center=true); //vent squares
        rotate([0,0,a+360/(2*n_leds)]) translate([led_offset,0,0]) circle(d=insert_w+bsl); //screw holes
      }
      rotate(-180/n_leds) translate([wire_offset,0]) circle(d=wire); //single hole for wire
    }
  }
  for (a=[360/n_leds:360/n_leds:360]) { //stuff above ring surface
    rotate([0,0,a]) translate([led_offset,0,wall]) bottom_holder(); //stops lateral motion of led
    rotate([0,0,a+360/(2*n_leds)]) translate([led_offset,0,0]) linear_extrude(wall+pcb_height+led_height) {
      *difference() { // protrusions for thread inserts
        circle(d=insert_w+2*wall);
        circle(d=insert_w);
      }
    }
  }
  linear_extrude(height=wall+pcb_height+led_height) { //ring walls around inner circle and outer circle
    difference() { //outer wall
      circle(d=od+2*vert_wall);
      circle(d=od);
    }
    difference() { //inner wall
      circle(d=id);
      circle(d=id-2*vert_wall);
    }
  }
}

module top() {
  linear_extrude(wall) { //ring shaped area, largest front surface
    difference() {
      circle(d=od+2*vert_wall);
      circle(d=id-2*vert_wall);
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate(a) translate([led_offset,0]) square(pcb_size-2*[lip,lip],center=true); //led cutouts
        rotate(a+360/(2*n_leds)) translate([led_offset,0]) circle(d=insert_w+bsl); //screw holes
      }
    }
  }
  translate([0,0,wall]) linear_extrude(led_height) { //lifted frames around leds
    for (a=[360/n_leds:360/n_leds:360]) {
      rotate(a) translate([led_offset,0]) {
        difference() {
          square(pcb_size-2*[slack,slack],center=true);
          square(pcb_size-2*[lip,lip],center=true);
        }
      }
    }
  }
  translate([0,0,wall]) linear_extrude(pcb_height+led_height) {
    for (a=[180/n_leds:360/n_leds:360]) { // protrusions for thread inserts
      rotate(a) translate([led_offset,0]) {
        difference() { 
          circle(d=insert_w+2*wall);
          circle(d=insert_w);
        }
      }
    }
  }
  linear_extrude(wall+pcb_height+led_height) { //ring walls around inner circle and outer circle
    difference() { //outer wall
      circle(d=od-2*slack);
      circle(d=od-2*slack-2*vert_wall);
    }
    difference() { //inner wall
      circle(d=id+2*slack+2*vert_wall);
      circle(d=id+2*slack);
    }
  }
}

module add_switch(x,y,z,a) {
  difference() {
    union() {
      children();
      translate([x,y,z]) rotate([0,-90,a]) linear_extrude(sw_depth,convexity=6) {
        difference() {
          square([sw_length,sw_width],center=true);
          translate([sw_dist/2,0]) circle(d=sw_hole);
          translate([-sw_dist/2,0]) circle(d=sw_hole);
        }
      }
    }
    translate([x,y,z]) rotate([0,-90,a]) cube([sw_rect[0],sw_rect[1],sw_dist*2+bsl],center=true);
  }
}

module bp_shape() { //footprint of a electronics compartment
  intersection() {
    translate([bp_offset,-bp_length/2]) square([bp_width,bp_length]);
    difference() {
      circle(d=od+2*vert_wall);
      circle(d=id-2*vert_wall);
    }
  }
}

module bp_raw() {
  linear_extrude(wall) {
    difference() {
      bp_shape();
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate(a+360/(2*n_leds)) translate([led_offset,0]) circle(d=insert_w+bsl); //screw holes
      }
      rotate(-180/n_leds) translate([wire_offset,0]) circle(d=wire); //single hole for wire
      translate([bp_offset+wall,-bp_length/2+wall]) square([sw_width,bp_length-2*wall]);
    }
  }
  linear_extrude(bp_height,convexity=4) {
    difference() {
      bp_shape();
      offset(r=-vert_wall) bp_shape();
    }
  }
}

module electronics() {
  add_switch(bp_offset+sw_width/2+vert_wall,bp_length/2-vert_wall,bp_height/2,90) bp_raw();
  translate([bp_offset+sw_width+vert_wall,-bp_length/2,0]) difference() {
    cube([vert_wall,bp_length,bp_height]);
    translate([vert_wall/2,four_wire_offset,bp_height/2]) rotate([0,90,0]) cylinder(d=wire,h=wall+bsl,center=true);
  }
  translate([0,0,bp_height+dt_h/2]) for (m=[0,1]) mirror([0,0,m]) difference() {
    linear_extrude(dt_h/2) bp_shape();
    for (tr=[0,-10]) translate([tr,0,0])hull() {
      linear_extrude(bsl,center=true) offset(r=-vert_wall-dt_offset)bp_shape();
      translate([0,0,dt_h/2]) linear_extrude(bsl) offset(r=-vert_wall)bp_shape();
    }
  }
}

module cover() {
  intersection() {
    linear_extrude(dt_h,center=true) bp_shape();
    for (tr=[0,-10]) translate([tr,0,0]) for (m=[0,1]) mirror([0,0,m]) hull() {
      linear_extrude(bsl) offset(r=-vert_wall-dt_offset-dt_slack) bp_shape();
      translate([0,0,dt_h/2-bsl]) linear_extrude(bsl) offset(r=-vert_wall-dt_slack) bp_shape();
    }
  }
}

module battery() {
  diam=14;
  len=40;
  wall=0.8;
  wire=2;
  module bat_cs() {
    offset=sqrt((diam/2+wall+wire/2)^2-(diam/2+wall/2)^2);
    translate([-diam/2-wall/2,0]) circle(d=diam);
    translate([diam/2+wall/2,0]) circle(d=diam);
    translate([0,offset]) circle(d=wire);
    translate([0,-offset]) circle(d=wire);
  }
  linear_extrude(len, convexity=6) {
    difference() {
      offset(r=wall) bat_cs();
      bat_cs();
    }
  }
}

module camera_mount() {

}

if (part=="top") top();
if (part=="bottom") bottom();
if (part=="battery") battery();
if (part=="electronics") electronics();
if (part=="cover") cover();
if (part=="camera_mount") camera_mount();
if (part=="NOSTL_assembly") {
  difference() {
    union() {
      bottom();
      translate([0,0,6]) mirror([0,0,1]) top();
    }
  rotate(30)cube([100,100,100]);
  }
}