$fs=1/1;
$fa=1/1;
bsl=1/100;
/*
difference() {
  union() { //outer shell
    cylinder(d=49,h=47,center=true);
    translate([44.5,22.5,0])cylinder(d=37.5,h=49,center=true);
  }
  union() {
  }
  union() { //holes
    cylinder(d=8,h=100,center=true);
    translate([44.5,22.5,0])cylinder(d=8,h=100,center=true);
  }
}
*/
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
arc1=arc(d=49,angle=[0,270],wedge=false);
line=[[0,-49/2],[20,-49/2]];
arc2=move([44.5,-22.5],p=arc(d=37.5,angle=[-160,125],wedge=false));
arc3=move([31,-5],p=arc(d=2,angle=[0,135],wedge=false,$fn=16));
path=path_join([arc1,line,arc2,arc3],relocate=false,closed=true);
difference() {
  union() {
    linear_extrude(height=47,center=true,convexity=3,)polygon(path);
    translate([44.5,-22.5,0])cylinder(d=37.5,h=48.5,center=true);
    translate([0,-26.5,0])scale([1,1,39/49])rotate([-90,0,0])cylinder(d=49,h=26.5);
  }
  cylinder(d=8,h=50,center=true);
  translate([44.5,-22.5,0] )cylinder(d=8,h=50,center=true);
  translate([0,-26.5-bsl,0])scale([1,1,34/43])rotate([-90,0,0])cylinder(d=43,h=36);
  translate([44.5,-22.5,0])cylinder(d=33,h=41,center=true);
  translate([44.5,-26.5-41/2,0]) cube([41,41,41],center=true);
  translate([44.5,-22.5-4,0])cube([18,30,43.5],center=true);
  translate([44.5,-22.5,0])rotate([-25,90,0])hull() {
    cylinder(d=29,h=37.5/2+bsl);
    translate([0,-40,0])cylinder(d=29,h=37.5/2+bsl);
  }
}