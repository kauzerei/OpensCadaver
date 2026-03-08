include <../import/BOSL2/std.scad>
$fs=1/1;
$fa=1/1;
bsl=1/100;

length=100;
width1=16;
width2=32;
thickness=3;
axle=4;
wall=1.2;
box_l=32;
slack=0.5;
switch_h=12;
r=3;
spring_d=8;
spring_h=4;
wire=5;

part="NOSTL_assembly";//[NOSTL_assembly,pedal,base]
opening=switch_h+thickness;
joint_position=[-box_l+wall+thickness+axle/2+slack,0,thickness+switch_h+thickness+axle/2];
box_h=3*thickness+switch_h+axle+slack+wall;

module pedal() {
  pedal_polygon=[[0,width1/2],[length-0.8*width2,width2/2],[length,0],[length-0.8*width2,-width2/2],[0,-width1/2]];
  pedal_shape=smooth_path(pedal_polygon,tangents=[[1,0],[1,0],[0,-1],[-1,0],[-1,0]],relsize=0.2,splinesteps=32);
  difference() {
    union() {
      down(thickness+axle/2) offset_sweep(pedal_shape,height=thickness,top=os_circle(r=thickness));
      ycyl(d=axle+2*thickness,h=width1);
    }
    ycyl(d=axle,h=width1+bsl);
  }
}

module switch_mount() {
  difference() {
    cuboid([13,6,11],rounding=-10,edges=BOTTOM,anchor=BOTTOM);
    up(11+bsl) cube([13,6,6],anchor=TOP);
    right(13/2)cube([23,3,11],anchor=BOTTOM+RIGHT);
  }
}

module platform() {
  add_h=(width2-2*slack-width1)/2;
  cuboid([length+joint_position[0],width2,thickness],anchor=LEFT+BOTTOM,rounding=r,edges=[RIGHT+FRONT,RIGHT+BACK]);
  difference() {
    cuboid([box_l,width2,box_h],anchor=RIGHT+BOTTOM,rounding=r,edges=[LEFT+FRONT,LEFT+BACK]);
    difference() {
      left(wall)up(thickness)cuboid([box_l-2*wall,width2-2*wall,box_h-wall-thickness],anchor=RIGHT+BOTTOM,rounding=r-wall,edges=[LEFT+FRONT,LEFT+BACK]);
      back(width2/2)translate(joint_position) ycyl(d1=axle+2*thickness,d2=axle+2*thickness+2*add_h,h=add_h,anchor=BACK);
      fwd(width2/2)translate(joint_position) ycyl(d2=axle+2*thickness,d1=axle+2*thickness+2*add_h,h=add_h,anchor=FRONT);
    }
    up(thickness)cube([2*wall+bsl,width2-2*wall,opening],anchor=BOTTOM);
    translate(joint_position) ycyl(d=axle,h=width2+bsl);
    back(width2/2+bsl)translate(joint_position) ycyl(d=2*axle,h=axle,anchor=BACK);
    fwd(width2/2+bsl)translate(joint_position) ycyl(d=2*axle,h=axle,anchor=FRONT);
    up(thickness)left(box_l+bsl)xcyl(d=wire,h=wall+2*bsl,anchor=LEFT+BOTTOM);
  }
  up(box_h)offset_sweep(rect([box_l,width2],rounding=[0,r,r,0],anchor=RIGHT),height=wall,top=os_circle(r=wall-bsl));
  right(42)cylinder(d=spring_d,h=spring_h+thickness);
  right(20)up(thickness)switch_mount();
}

if (part=="NOSTL_assembly") {
  translate(joint_position) pedal();
  platform();
}
if (part=="pedal") pedal();
if (part=="base") platform();