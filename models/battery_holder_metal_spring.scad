battery_d=19;
battery_l=65;
spring_depth=5;
spring_thickness=1.3;
spring_width=7;
spring_height=14.5;
pcb_mount=true;
pin_w=2;
pin_l=5;
wall=1.2;
bottom=0.8;
channel=3;
cover_screw=3;
insert_depth=6;
box_width=23;
jack_d=12;
arc_depth=0.75*battery_d;
arc_width=0.8*battery_l;
arc_r=(arc_width^2+4*arc_depth^2)/arc_depth/8;
bsl=1/100;
$fa=1/2;
$fs=1/2;

function distributor(start,end, distance)=let(offset=((end-start)%distance)/2)[for (x=[start+offset+distance/2:distance:end-distance/2]) x];

module spring_cutout(sd,st,sw,sh,bd,w,pw,pl,pm) {
  cutout=(bd-sh)/2;
  spring_sink=pm?cutout:0;
  translate([0,-sw/2,cutout-spring_sink])cube([st,sw,bd-cutout+spring_sink]);
  translate([0,-sw/2,bd-cutout-spring_sink])cube([st+wall+bsl,sw,cutout+bsl+spring_sink]);
  translate([0,-sw/2+w,0])cube([st+wall+bsl,sw-2*w,bd+bsl]);
  if(pm)translate([0,-pw/2,-pl])cube([st+bsl,pw,pl+bsl]);
}

module single_cell(bd,bl,sd,st,sw,sh,w,b,pl,pw,pm) {
  difference() {
    cube([bl+2*sd+2*w,bd+2*w,bd+b]);
    translate([w+st+w,w,b]) cube([bl+2*sd-2*st-2*w,bd,bd+bsl]);
    translate([w,w+bd/2,b])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w,pw=pw,pl=pw,pm=pm);
    translate([bl+2*sd+w,w+bd/2,b])rotate([0,0,180])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w,pw=pw,pl=pw,pm=pm);
    translate([bl/2+sd+w,-bsl,bd+b+arc_r-arc_depth])rotate([-90,0,0])cylinder(r=arc_r,h=bd+2*w+2*bsl);
  }
}

module screw_mount(wall,d,height) {
  difference() {
    translate([0,0,-2*height])cube([d+wall,d+wall,height*2]);
    translate([(d+wall),(d+wall),-height]) rotate([0,135,45])translate([0,-2*height])cube([height*4,height*4,height*4]);
    translate([d/2,d/2,-height]) cylinder(d=d,h=height+bsl);
  }
}

module switch_hole() {
circle(d=6.5);
/*
  square([8,4],center=true);
  translate([-7.5,0]) circle(d=3);
  translate([7.5,0]) circle(d=3);
  */
}

module box(width,depth,height,wall,bottom,insert_d,insert_h) {
  difference() {
    translate([0,-width-wall,0]) cube([depth+2*wall,width+wall,height+bottom]);
    translate([wall,-width,bottom]) cube([depth,width+bsl,height+bsl]);
    translate([-bsl,-width/2,bottom+height/2])rotate([0,90,0])linear_extrude(height=wall+2*bsl) switch_hole();
    for (tr=distributor(wall+16,wall+depth,16)) translate([tr,-width+bsl,bottom+height/2]) rotate([90,0,0]) intersection() {
  cylinder(d=jack_d,h=wall+2*bsl);
  translate([-10.5/2,-jack_d/2,0]) cube([10.5,jack_d,wall+2*bsl]);
  }
  }
  translate([wall,0,height+bottom])rotate([0,0,-90]) screw_mount(wall=wall,d=insert_d,height=insert_h);
  translate([wall,-width,height+bottom])rotate([0,0,0]) screw_mount(wall=wall,d=insert_d,height=insert_h);
  translate([wall+depth,0,height+bottom])rotate([0,0,180]) screw_mount(wall=wall,d=insert_d,height=insert_h);
  translate([wall+depth,-width,height+bottom])rotate([0,0,90]) screw_mount(wall=wall,d=insert_d,height=insert_h);
}

module double_battery_holder(bd,bl,sd,st,sw,sh,w,b,c,ih,id) {
  difference() {
    union() {
      single_cell(bd=bd,bl=bl,sd=sd,st=st,sw=sw,sh=sh,w=w,b=b);
      translate([0,bd+w,0])single_cell(bd=bd,bl=bl,sd=sd,st=st,sw=sw,sh=sh,w=w,b=b);
      box(width=box_width,depth=bl+2*sd,height=bd,wall=w,bottom=b,insert_d=id,insert_h=ih);
    }
    for (tr=[[w+st+w+c/2,w/2,b+c/2],
              [w+st+w+c/2,w/2,b+c/2+w+c],
              [w+st+w+c/2,w/2+bd+w,b+c/2],
              [w+st+w+c/2+bl+2*sd-2*st-2*w-c,w/2+bd+w,b+c/2],
             ]) translate(tr) rotate([-90,0,0])cylinder(d=c,h=w+bsl,center=true);
    for (x=distributor(w,w+bl+2*sd,20))
    for (y=distributor(-box_width-w,bd*2+3*w,20))
    translate([x,y,-bsl]) cylinder(d1=5,d2=5+2*b,h=b+2*bsl);
  }
}

//double_battery_holder(bd=battery_d,bl=battery_l,sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,w=wall,b=bottom,c=channel,ih=insert_depth,id=cover_screw);
single_cell(bd=battery_d,bl=battery_l,sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,w=wall,b=bottom,pw=pin_w,pl=pin_l,pm=pcb_mount);
//spring_cutout(bd=battery_d,sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,w=wall,pw=pin_w,pl=pin_l);
