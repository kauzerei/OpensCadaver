include <../import/BOSL2/std.scad>

cell_diameter=17;
cell_height=35;
bat_height=45;
flat=15;
slack=0.8;
contact_width=5.5;
contact_bump=0.5;
contact_channel=0.6;
$fa=1/2;
$fs=1/2;
bsl=1/100;
thickness=(bat_height-cell_height)/2;


module spring_cutout(sd=5,st=1.3,sw=7,sh=14.5,bd=19,w=1.6) {
  cutout=(bd-sh)/2;
  translate([0,-sw/2,cutout])cube([st,sw,bd-cutout+bsl]);
  translate([0,-sw/2,bd-cutout])cube([st+w+bsl,sw,cutout+bsl]);
  translate([0,-sw/2+w,0])cube([st+w+bsl,sw-2*w,bd+bsl]);
}
/*
//points of lower contact path
p1=[(-cell_diameter-contact_width)/2,0,0];
p0=p1+[thickness/2,0,-thickness/2];
p2=[-cell_diameter/2,0,contact_bump+contact_channel];
p3=[-cell_diameter/2+contact_width/2,0,0];
p4=-p3;
p5=[cell_diameter/2,0,contact_bump+contact_channel];
p6=-p1;
p7=p6+[-thickness/2,0,-thickness/2];
path=[p0,p1,p2,p3,p4,p5,p6,p7];
*/

rotate([90,0,0]) {
  difference() {
    linear_extrude(height=bat_height,center=true,convexity=3) {
      translate([-cell_diameter/2,0]) circle(d=cell_diameter);
      translate([cell_diameter/2,0]) circle(d=cell_diameter);
      translate([-cell_diameter/2,-cell_diameter/2]) square([cell_diameter,flat]);
    }
    //batteries cutouts
    translate([-cell_diameter/2,0,0]) cylinder(d=cell_diameter+slack,h=cell_height,center=true);
    translate([cell_diameter/2,0,0]) cylinder(d=cell_diameter+slack,h=cell_height,center=true);
    //top contacts
    translate([-cell_diameter/2-contact_width/2,-contact_width/2-contact_channel,cell_height/2-bsl]) cube([contact_width,contact_channel,thickness/2]);
    translate([cell_diameter/2-contact_width/2,-contact_width/2-contact_channel,cell_height/2-bsl]) cube([contact_width,contact_channel,thickness/2]);
    translate([-cell_diameter/2-contact_width/2,contact_width/2,cell_height/2-bsl]) cube([contact_width,cell_diameter/2-contact_width/2,contact_channel]);
    translate([cell_diameter/2-contact_width/2,contact_width/2,cell_height/2-bsl]) cube([contact_width,cell_diameter/2-contact_width/2,contact_channel]);
    translate([-cell_diameter/2-contact_width/2,cell_diameter/2-contact_channel*2,cell_height/2-bsl]) cube([contact_width,2*contact_channel,thickness+2*bsl]);
    translate([cell_diameter/2-contact_width/2,cell_diameter/2-contact_channel*2,cell_height/2-bsl]) cube([contact_width,2*contact_channel,thickness+2*bsl]);
    translate([-cell_diameter/2-contact_width/2,cell_diameter/2-contact_width-contact_channel,bat_height/2-contact_channel]) cube([contact_width,contact_width,contact_channel+bsl]);
    translate([cell_diameter/2-contact_width/2,cell_diameter/2-contact_width-contact_channel,bat_height/2-contact_channel]) cube([contact_width,contact_width,contact_channel+bsl]);
    translate([-cell_diameter/2-contact_width/2,cell_diameter/2-contact_width-contact_channel,bat_height/2-thickness/2]) cube([contact_width,contact_channel,thickness/2]);
    translate([cell_diameter/2-contact_width/2,cell_diameter/2-contact_width-contact_channel,bat_height/2-thickness/2]) cube([contact_width,contact_channel,thickness/2]);
    //bottom contacts
    translate([-cell_diameter/2-contact_width/2-contact_channel,-contact_width/2,-bat_height/2+thickness/2]) cube([contact_channel,contact_width,thickness/2+bsl]);
    translate([cell_diameter/2+contact_width/2,-contact_width/2,-bat_height/2+thickness/2]) cube([contact_channel,contact_width,thickness/2+bsl]);
  }
//piptiki
  for (m1=[[0,0,0],[0,0,1]]) for (m2=[[0,0,0],[1,0,0]]) mirror(m1) mirror(m2) 
    translate([cell_diameter/2,0,-cell_height/2]) linear_extrude(height=contact_bump, scale=0.3) square(contact_width,center=true);
}
//  rotate([90,-90,0]) spring_cutout();
*  translate([0,0,-cell_height/2-contact_channel/2+bsl])for (i=[0:1:len(path)-2]) hull(){
    translate(path[i]) rotate([90,0,0])cylinder(d=contact_channel,h=contact_width,center=true);
    translate(path[i+1]) rotate([90,0,0])cylinder(d=contact_channel,h=contact_width,center=true);
    }



