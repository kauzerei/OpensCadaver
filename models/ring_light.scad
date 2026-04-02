$fs=1/1;
$fa=1/1;
bsl=1/100;

part="NOSTL_assembly";//[bottom,top,enclosure,battery,cover,camera_mount,NOSTL_assembly]

pcb_height=1; // thickness of the board where the led is mounted
led_height=1; // how hight led protrudes above the board surface
pcb_mount_size=[30.5,28.4]; //distances between mount edges of the board (board itself is bigger)
pcb_size=[32,32]; //total size for calculating proper spacing

slack=0.2; //extra space aroung led mounting features
hook_width=12; //width of led mounting features
wall=1.2; //horizontal wall thickness
vert_wall=1.2; //vertical wall thickness
lip=1; //thickness of the frame around led
insert_w=3.2; //diameters of holes, same for threaded inserts and for screws to go through

n_leds=6; //number of leds

led_offset=0.5*pcb_size[1]/tan(180/n_leds)+0.5*pcb_size[0]; //offset of led center from origin.
hook_depth=vert_wall+pcb_height+led_height;
id=2*(led_offset-pcb_size[0]/2-hook_depth-vert_wall-slack); //inner diameter of the ring, without walls
od=sqrt((led_offset+pcb_size[0]/2)^2+(pcb_size[1]/2)^2)*2+4*vert_wall; //outer diameter

sw_dist=15; //distance between switch mounting points
sw_depth=3; //distance to mounting surface
sw_rect=[7,3.5]; //cutout for slider
sw_hole=3.5; //mounting hole diameter
sw_wall=1.6; //min distance from any hole to mounting surface side
sw_length=sw_dist+sw_hole+2*sw_wall; //larger length of mounting surface
sw_width=2*sw_wall+max([sw_hole,sw_rect[1]]); //shorter side of mounting surface

bp_length=60; //outer length of battery pack enclusire, longer for longer batteries
bp_height=sw_length; //battery pack length, currently defined by switch, can be bigger
bp_width=(od-id)/2+2*vert_wall; //width of enclosure, with walls: outside dimension
bp_offset=od/2+vert_wall-bp_width; //how close to center the battery compartment starts

dt_h=2; //total height of dovetatil profile
dt_offset=1; //dovetailness of dovetail, 1mm offset on 1mm half-height is 45 degrees
dt_slack=0.0; //wiggle room in horizontal direction

wire=4; //holes for wires
tweak_wire=3; //manual position adjustment of hole for power to leds
wire_offset=id/2+wire/2+vert_wall+slack+tweak_wire; //distance of hole from origin
four_wire_offset_tweak=8; //manual position adjustment of hole for battery cables
four_wire_offset=bp_length-vert_wall-wire/2-sw_depth-four_wire_offset_tweak;

module hook() { //holds led from one side
  hull() {
    translate([-hook_width/2,0,0]) cube([hook_width,vert_wall,pcb_height+led_height]);
    scale([1,1,0]) translate([-hook_width/2,0,0]) cube([hook_width,vert_wall+pcb_height+led_height,1]);
  }
}

module bottom_holder() { //holds one led from 4 sides
  rot=[0,90,180,270];
  shift=[pcb_mount_size[1]/2,pcb_mount_size[0]/2,pcb_mount_size[1]/2,pcb_mount_size[0]/2];
  for (i=[0:1:3]) rotate([0,0,rot[i]]) translate([0,shift[i]+slack,0]) hook();
}

module bottom() {
  linear_extrude(height=wall) { //ring shaped area, large back surface
    difference() {
      circle(d=od);
      circle(d=id);
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate([0,0,a]) translate([led_offset,0,0]) square(pcb_mount_size-2*[lip,lip],center=true); //vent squares
        rotate([0,0,a+360/(2*n_leds)]) translate([led_offset,0,0]) circle(d=insert_w+bsl); //screw holes
      }
      rotate(-180/n_leds) translate([wire_offset,0]) circle(d=wire); //single hole for wire
    }
  }
  for (a=[360/n_leds:360/n_leds:360]) { //stuff above ring surface
    rotate([0,0,a]) translate([led_offset,0,wall]) bottom_holder(); //stops lateral motion of led
    rotate([0,0,a+360/(2*n_leds)]) translate([led_offset,0,0]) linear_extrude(wall+pcb_height+led_height) {
      *difference() { // protrusions for thread inserts, here deactivated, because present on other side
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
        rotate(a) translate([led_offset,0]) square(pcb_mount_size-2*[lip,lip],center=true); //led cutouts
        rotate(a+360/(2*n_leds)) translate([led_offset,0]) circle(d=insert_w+bsl); //screw holes
      }
    }
  }
  translate([0,0,wall]) linear_extrude(led_height) { //lifted frames around leds
    for (a=[360/n_leds:360/n_leds:360]) {
      rotate(a) translate([led_offset,0]) {
        difference() {
          square(pcb_mount_size-2*[slack,slack],center=true);
          square(pcb_mount_size-2*[lip,lip],center=true);
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

module add_switch(x,y,z,a) { //module for placing switch mounting geometry on child
  difference() {
    union() { //add features
      children();
      translate([x,y,z]) rotate([0,-90,a]) linear_extrude(sw_depth,convexity=6) { //mounting geometry
        difference() {
          square([sw_length,sw_width],center=true);
          translate([sw_dist/2,0]) circle(d=sw_hole);
          translate([-sw_dist/2,0]) circle(d=sw_hole);
        }
      }
    } //subtract feature
    translate([x,y,z]) rotate([0,-90,a]) cube([sw_rect[0],sw_rect[1],sw_dist*2+bsl],center=true); //hole for switching
  }
}

module enclosure_shape() { //footprint of a electronics compartment
  intersection() {
    translate([bp_offset,-bp_length/2]) square([bp_width,bp_length]);
    difference() {
      circle(d=od+2*vert_wall);
      circle(d=id-2*vert_wall);
    }
  }
}

module enclosure_raw() { //base shape for enclosure, no wall, no switch related features
  linear_extrude(wall) { //bottom wall for mounting
    difference() {
      enclosure_shape();
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate(a+360/(2*n_leds)) translate([led_offset,0]) circle(d=insert_w+bsl); //screw holes
      }
      rotate(-180/n_leds) translate([wire_offset,0]) circle(d=wire); //single hole for power wire
      translate([bp_offset+wall,-bp_length/2+wall]) {
        square([sw_width,bp_length-2*wall]); //decided to have this opening for ease of mounting everything
      }
    }
  }
  linear_extrude(bp_height,convexity=4) { //main walls of enclosure
    difference() {
      enclosure_shape();
      offset(r=-vert_wall) enclosure_shape();
    }
  }
}

module enclosure() { //enclosure with all features
  add_switch(bp_offset+sw_width/2+vert_wall,bp_length/2-vert_wall,bp_height/2,90) enclosure_raw();
  translate([bp_offset+sw_width+vert_wall,-bp_length/2,0]) difference() { //in-between-wall
    cube([vert_wall,bp_length,bp_height]);
    translate([vert_wall/2,four_wire_offset,bp_height/2]) rotate([0,90,0]) cylinder(d=wire,h=wall+bsl,center=true);
  }
  translate([0,0,bp_height+dt_h/2]) for (m=[0,1]) mirror([0,0,m]) difference() { //dovetail feature
    linear_extrude(dt_h/2) enclosure_shape(); //subtract from solid shape to form walls
    for (tr=[0,-10]) translate([tr,0,0]) hull() { //extended with translate x -10 to make longer for opening
      linear_extrude(bsl,center=true) offset(r=-vert_wall-dt_offset)enclosure_shape();
      translate([0,0,dt_h/2]) linear_extrude(bsl) offset(r=-vert_wall)enclosure_shape();
    }
  }
}

module cover() { //dovetail cover
  intersection() { //cut to shape to form vertical wall where it's cut
    linear_extrude(dt_h,center=true) enclosure_shape();
    for (tr=[0,-10]) translate([tr,0,0]) for (m=[0,1]) mirror([0,0,m]) hull() { //elongate in x dir with translate
      linear_extrude(bsl) offset(r=-vert_wall-dt_offset-dt_slack) enclosure_shape();
      translate([0,0,dt_h/2-bsl]) linear_extrude(bsl) offset(r=-vert_wall-dt_slack) enclosure_shape();
    }
  }
}

module battery() { //isolating tubes to make battery look safer lol
  diam=14; //cell diameter
  len=40; //cell length
  wall=0.8; //wall thickness
  wire=2; //wire diameter (better oversize)
  module bat_cs() { //cross-section of 2 batteries and 2 wires
    offset=sqrt((diam/2+wall+wire/2)^2-(diam/2+wall/2)^2);
    translate([-diam/2-wall/2,0]) circle(d=diam);
    translate([diam/2+wall/2,0]) circle(d=diam);
    translate([0,offset]) circle(d=wire);
    translate([0,-offset]) circle(d=wire);
  }
  linear_extrude(len, convexity=6) { //form walls with subtracting battery cross section from its offset version
    difference() { 
      offset(r=wall) bat_cs();
      bat_cs();
    }
  }
}

module camera_mount() { //very ugly camera-specific module
  x_offset=-27.5; //offset of mounting thread from origin
  y_offset=-20;
  z_offset=45;
  screw=7; //screw thread
  head=20; //screw head diameter
  add_depth=12; //size of camera plate
  add_width=20;
  add_mount=3; //additional material around mount holes
  wall=2;
  linear_extrude(wall) difference() {
    for (i=[1:1:3]) hull() {
      rotate(180/n_leds+i*360/n_leds) translate([led_offset,0]) circle(d=2*add_mount+insert_w);
      rotate(180/n_leds+(i+1)*360/n_leds) translate([led_offset,0]) circle(d=2*add_mount+insert_w);
    }
    for (i=[1:1:4]) rotate(180/n_leds+i*360/n_leds) translate([led_offset,0]) circle(d=insert_w);
  }
  difference() {
    hull() {
      translate([x_offset-wall/2,y_offset,z_offset]) cube([wall,add_width*2,add_depth*2],center=true);
      rotate(180/n_leds+2*360/n_leds) translate([led_offset,0,wall]) cylinder(d=2*add_mount+insert_w,h=bsl);
      rotate(180/n_leds+(2+1)*360/n_leds) translate([led_offset,0,wall]) cylinder(d=2*add_mount+insert_w,h=bsl);
    }
    rotate(180/n_leds+2*360/n_leds) translate([led_offset,0,wall]) cylinder(d=2*insert_w,h=z_offset);
    rotate(180/n_leds+(2+1)*360/n_leds) translate([led_offset,0,wall]) cylinder(d=2*insert_w,h=z_offset);
    translate([x_offset,y_offset,z_offset]) rotate([0,90,0])cylinder(d=screw,h=100,center=true);
    translate([x_offset-wall,y_offset,z_offset]) rotate([0,-90,0])cylinder(d=head,h=100);
    }
}

if (part=="top") top();
if (part=="bottom") bottom();
if (part=="battery") battery();
if (part=="enclosure") enclosure();
if (part=="cover") cover();
if (part=="camera_mount") camera_mount();
if (part=="NOSTL_assembly") {
  difference() {
    union() {
      bottom();
      translate([0,0,6]) mirror([0,0,1]) top();
      translate([0,0,-4]) mirror([0,0,1]) enclosure();
    }
  rotate(30)cube([100,100,100]);
  }
}