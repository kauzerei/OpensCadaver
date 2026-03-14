$fs=1/1;
$fa=1/1;
bsl=1/100;

part="bottom";//[bottom,top]

pcb_height=1;
led_height=1;
pcb_size=[30.5,28.4];

slack=0.3;
hook_width=12;
wall=1.6;
vert_wall=1.2;
lip=1;
insert_w=3.2;

n_leds=6;
led_offset=43;

id=45;
od=128;

module hook() {
  hull() {
    translate([-hook_width/2,0,0]) cube([hook_width,vert_wall,pcb_height+led_height]);
    scale([1,1,0]) translate([-hook_width/2,0,0]) cube([hook_width,vert_wall+pcb_height+led_height,1]);
  }
}

module bottom_holder() {
  rot=[0,90,180,270];
  shift=[pcb_size[1]/2,pcb_size[0]/2,pcb_size[1]/2,pcb_size[0]/2];
  for (i=[0:1:3]) rotate([0,0,rot[i]]) translate([0,shift[i]+slack,0]) hook();
}

module bottom() {
  linear_extrude(height=wall) {
    difference() {
      circle(d=od);
      circle(d=id);
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate([0,0,a]) translate([led_offset,0,0]) square(pcb_size-2*[lip,lip],center=true);
        rotate([0,0,a+360/(2*n_leds)]) translate([led_offset,0,0]) circle(d=insert_w+bsl);
      }
    }
  }
  for (a=[360/n_leds:360/n_leds:360]) {
    rotate([0,0,a]) translate([led_offset,0,wall]) bottom_holder();
    rotate([0,0,a+360/(2*n_leds)]) translate([led_offset,0,0]) linear_extrude(wall+pcb_height+led_height) difference() {
      circle(d=insert_w+2*wall);
      circle(d=insert_w);
    }
  }
  linear_extrude(height=wall+pcb_height+led_height) {
    difference() {
      circle(d=od+2*vert_wall);
      circle(d=od);
    }
    difference() {
      circle(d=id);
      circle(d=id-2*vert_wall);
    }
  }
}

module top() {
  linear_extrude(wall) {
    difference() {
      circle(d=od+1*vert_wall);
      circle(d=id-2*vert_wall);
      for (a=[360/n_leds:360/n_leds:360]) {
        rotate(a) translate([led_offset,0]) square(pcb_size-2*[lip,lip],center=true);
        rotate(a+360/(2*n_leds)) translate([led_offset,0]) circle(d=insert_w+bsl);
      }
    }
  }
  translate([0,0,wall]) linear_extrude(led_height) {
    for (a=[360/n_leds:360/n_leds:360]) {
      rotate(a) translate([led_offset,0]) difference() {
        square(pcb_size-2*[slack,slack],center=true);
        square(pcb_size-2*[lip,lip],center=true);
      }
    }
  }
  linear_extrude(wall+pcb_height+led_height) {
    difference() {
      circle(d=od-2*slack);
      circle(d=od-2*slack-2*vert_wall);
    }
    difference() {
      circle(d=id-2*slack+2*vert_wall);
      circle(d=id-2*slack);
    }
  }
}

if (part=="top") top();
if (part=="bottom") bottom();