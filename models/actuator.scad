// Magnetic actuator draft
// Developed for LARS
$fs=1/2;
$fa=1/1;
bissl=1/100;
part="all";//[frontcap,endcap,spoolcenter,coupling,beater,bracket]
wall=0.8;
air=0.5;
iron_d=4;
coil_id=iron_d+2*air;
coil_od=coil_id+2*wall;
length=30;

border=3;
cap_recess=coil_od+2*air;
cap_thickness=2*wall;
cap_od=coil_od+2*border;
beater_travel=15;
beater_d=iron_d-2*air;
beater_inside_coil=20;
length_beater=20;
screw=4;
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
*coil_spool(id=5,wall=0.8,height=30,border=5,extra=20);

module spoolcenter(id,wall,length) {
  difference() {
    cylinder(h=length,d=id+2*wall);
    translate([0,0,-bissl])cylinder(d=id, h=length+2*bissl);
  }
}

module endcap(id,recess,thickness,width,travel) {
  difference() {
    translate([0,0,-travel])cylinder(d1=id+thickness,d2=width,h=thickness+travel);
    translate([0,0,thickness/2])cylinder(d=recess,h=thickness/2+bissl);
    translate([0,0,-travel+thickness])cylinder(d=id,h=thickness+travel+bissl);
  }
}

module frontcap(id,recess,thickness,width) {
  difference() {
    cylinder(d=width,h=thickness);
    translate([0,0,thickness/2])cylinder(d=recess,h=thickness/2+bissl);
    translate([0,0,-bissl])cylinder(d=id,h=thickness+2*bissl);
  }
}

module coupling(id, od, wall, depth, thickness) {
  difference() {
    cylinder(d=od,h=depth+thickness);
    translate([0,0,thickness]) cylinder(d=od-2*wall,h=depth+bissl);
    translate([0,0,-bissl]) cylinder(d=id,h=thickness+2*bissl);
    
  }
}

module beater(iron_d,beater_d,length_coil,length_beater, holding_d, holding_h) {
  cylinder(d=iron_d,h=length_coil);
  translate([0,0,length_coil])cylinder (d1=iron_d,d2=holding_d,h=(holding_d-iron_d)/2);
  translate([0,0,length_coil+(holding_d-iron_d)/2])cylinder (d=holding_d,h=holding_h);
  translate([0,0,length_coil+holding_h]) cylinder (d=beater_d,h=length_beater);
}

module bracket(diameter, length, wall, screw) {
  difference() {
    cube([diameter+4*wall+2*screw,length+2*wall,diameter/2+wall]);
    translate([diameter/2+2*wall+screw,-bissl,0])rotate([-90,0,0])cylinder(d=diameter-2*wall, h=length+2*wall+2*bissl);
    translate([diameter/2+2*wall+screw,wall,0])rotate([-90,0,0])cylinder(d=diameter, h=length);
    for (tr=[[diameter+3*wall+1.5*screw,length+wall-screw/2,-bissl],[wall+0.5*screw,length+wall-screw/2,-bissl],[diameter+3*wall+1.5*screw,wall+screw/2,-bissl],[wall+screw/2,wall+screw/2,-bissl]])translate(tr)cylinder(d=screw,h=diameter/2+wall+2*bissl);
  }
}
if (part=="all") {
translate([0,0,-cap_thickness/2-air])frontcap(id=coil_id,recess=cap_recess,thickness=cap_thickness,width=cap_od);
translate([0,0,length+cap_thickness/2+air])mirror([0,0,1])endcap(id=coil_id,recess=cap_recess,thickness=cap_thickness,width=cap_od,travel=10);
spoolcenter(id=coil_id,wall=wall,length=length);
translate([0,0,-beater_travel-1.5*cap_thickness-2*air])coupling(id=coil_id, od=cap_od, wall=wall, depth=beater_travel, thickness=cap_thickness);
translate([0,0,beater_inside_coil-cap_thickness])mirror([0,0,1])beater(iron_d=iron_d-2*air,beater_d=beater_d,length_coil=beater_inside_coil,length_beater=length_beater, holding_d=cap_od-2*wall-2*air, holding_h=2*wall);
translate([-cap_od/2-screw-2*wall-air,0,cap_thickness-air/2])rotate([-90,0,0])bracket(diameter=cap_od+2*air, length=beater_travel+2*cap_thickness+2*air, wall=wall, screw=screw);
}

if(part=="frontcap")frontcap(id=coil_id,recess=cap_recess,thickness=cap_thickness,width=cap_od);
if(part=="endcap")endcap(id=coil_id,recess=cap_recess,thickness=cap_thickness,width=cap_od,travel=10);
if(part=="spoolcenter")spoolcenter(id=coil_id,wall=wall,length=length);
if(part=="coupling")coupling(id=coil_id, od=cap_od, wall=wall, depth=beater_travel, thickness=cap_thickness);
if(part=="beater")beater(iron_d=iron_d-2*air,beater_d=beater_d,length_coil=beater_inside_coil,length_beater=length_beater, holding_d=cap_od-2*wall-2*air, holding_h=2*wall);
if(part=="bracket")mirror([0,0,1])bracket(diameter=cap_od+2*air, length=beater_travel+2*cap_thickness+2*air, wall=wall, screw=screw);