include <../import/BOSL2/std.scad>

cell_diameter=16;
cell_height=34;
bat_height=45;
flat=15;
slack=0.8;
contact_width=5;
contact_bump=1;
contact_channel=0.5;
$fa=1/2;
$fs=1/2;
bsl=1/20;
thickness=(bat_height-cell_height)/2;

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


//rotate([90,0,0])
difference() {
  union() {
    difference() {
      linear_extrude(height=bat_height,center=true,convexity=3) {
        translate([-cell_diameter/2,0]) circle(d=cell_diameter);
        translate([cell_diameter/2,0]) circle(d=cell_diameter);
        translate([-cell_diameter/2,-cell_diameter/2]) square([cell_diameter,flat]);
      }
      translate([-cell_diameter/2,0,0]) cylinder(d=cell_diameter+slack,h=cell_height,center=true);
      translate([cell_diameter/2,0,0]) cylinder(d=cell_diameter+slack,h=cell_height,center=true);
    }
    for (m1=[[0,0,0],[0,0,1]]) for (m2=[[0,0,0],[1,0,0]]) mirror(m1) mirror(m2) 
      translate([cell_diameter/2,0,-cell_height/2]) linear_extrude(height=contact_bump, scale=0.3) square(contact_width,center=true);
  }
  translate([0,0,-cell_height/2-contact_channel/2+bsl])for (i=[0:1:len(path)-2]) hull(){
    translate(path[i]) rotate([90,0,0])cylinder(d=contact_channel,h=contact_width,center=true);
    translate(path[i+1]) rotate([90,0,0])cylinder(d=contact_channel,h=contact_width,center=true);
  }
}



