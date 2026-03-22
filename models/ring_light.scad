$fs=1/1;
$fa=1/1;
bsl=1/100;

part="battery";//[bottom,top,battery,NOSTL_assembly]

pcb_height=1;
led_height=1;
pcb_size=[30.5,28.4];
dcdc_thickness=8;

slack=0.2;
hook_width=12;
wall=1.6;
vert_wall=1.2;
lip=1;
insert_w=3.2;

n_leds=6;
led_offset=43;
hole_dist=2*led_offset*sin(180/n_leds);

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
      circle(d=od+2*vert_wall);
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
      circle(d=id+2*slack+2*vert_wall);
      circle(d=id+2*slack);
    }
  }
}

module battery() {
  battery_d=19;
  battery_l=65;
  spring_depth=5;
  spring_thickness=1.3;
  spring_width=7;
  spring_height=14.5;
  wall=vert_wall;
  bottom=wall;
  channel=3;
  
  arc_depth=0.75*battery_d;
  arc_width=0.8*battery_l;
  arc_r=(arc_width^2+4*arc_depth^2)/arc_depth/8;
  
  module spring_cutout(sd,st,sw,sh,bd,w) {
    cutout=(bd-sh)/2;
    translate([0,-sw/2,cutout])cube([st,sw,bd-cutout+bsl]);
    translate([0,-sw/2,bd-cutout])cube([st+wall+bsl,sw,cutout+bsl]);
    translate([0,-sw/2+w,0])cube([st+wall+bsl,sw-2*w,bd+bsl]);
  }
  
  module single_cell(bd,bl,sd,st,sw,sh,w,b) {
    difference() {
      cube([bl+2*sd+2*w,bd+2*w,bd+b]);
      translate([w+st+w,w,b]) cube([bl+2*sd-2*st-2*w,bd,bd+bsl]);
      translate([w,w+bd/2,b])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w);
      translate([bl+2*sd+w,w+bd/2,b])rotate([0,0,180])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w);
      translate([bl/2+sd+w,-bsl,bd+b+arc_r-arc_depth])rotate([-90,0,0])cylinder(r=arc_r,h=bd+2*w+2*bsl);
    }
  }
  
  module double_battery_holder(bd,bl,sd,st,sw,sh,w,b,c) {
    difference() {
      union() {
        single_cell(bd=bd,bl=bl,sd=sd,st=st,sw=sw,sh=sh,w=w,b=b);
        translate([0,bd+w,0])single_cell(bd=bd,bl=bl,sd=sd,st=st,sw=sw,sh=sh,w=w,b=b);
      }
      translate([w+st+w+c/2+bl+2*sd-2*st-2*w-c,w/2+bd+w,b+c/2]) rotate([-90,0,0])cylinder(d=c,h=w+bsl,center=true);
      translate([-bsl,bd+w-c/2,b+c/2]) rotate([0,90,0])cylinder(d=c,h=sd+bsl);
      translate([-bsl,bd+2*w+c/2,b+c/2]) rotate([0,90,0])cylinder(d=c,h=sd+bsl);
      translate([bl/2+hole_dist/2,bd*0.75,-bsl]) cylinder(h=w+2*bsl,d=insert_w);
      translate([bl/2-hole_dist/2,bd*0.75,-bsl]) cylinder(h=w+2*bsl,d=insert_w);
    }
  }

  double_battery_holder(bd=battery_d,bl=battery_l,sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,w=vert_wall,b=wall,c=channel);
  difference() {
    translate([-wall-dcdc_thickness,0,0]) cube([wall+dcdc_thickness,2*battery_d+3*vert_wall,wall+battery_d]);
    translate([-dcdc_thickness,vert_wall,-bsl]) cube([dcdc_thickness,2*battery_d+vert_wall,battery_d]);
  }
  
}

if (part=="top") top();
if (part=="bottom") bottom();
if (part=="battery") battery();
if (part=="NOSTL_assembly") {
  difference() {
    union() {
      bottom();
      translate([0,0,6]) mirror([0,0,1]) top();
    }
  cube([100,100,100]);
  }
}