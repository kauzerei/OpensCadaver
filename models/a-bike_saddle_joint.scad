include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fs=1/1;
$fa=1/1;
bsl=1/100;
arc1=arc(d=49,angle=[0,270],wedge=false); //arc of a bigger circle of outer shell
line=[[0,-49/2],[20,-49/2]]; //straight line towards smaller circle
arc2=move([44.5,-22.5],p=arc(d=37.5,angle=[-160,125],wedge=false)); //smaller circle of outer shell
arc3=move([31,-5],p=arc(d=2,angle=[0,135],wedge=false,$fn=16)); //stopper feature
path=path_join([arc1,line,arc2,arc3],relocate=false,closed=true); //outline of outer shell
path2=arc(points=[[-13,24.5,0],[11.5,11.5,0],[14,1.5,0]]); //arc that a brake cable follows
path3=[[0,0,0],[0,-3,0]];

module brakeless() {
  difference() {
    union() {
      linear_extrude(height=47,center=true,convexity=3,)polygon(path);
      translate([44.5,-22.5,0])cylinder(d=37.5,h=48.5,center=true);
      translate([0,-26.5,0])scale([1,1,39/49])rotate([-90,0,0])cylinder(d=49,h=26.5);  
    }
    cylinder(d=8,h=50,center=true);
    translate([44.5,-22.5,0] )cylinder(d=8,h=50,center=true);
    //translate([0,-26.5-bsl,0])scale([1,1,35/44])rotate([-90,0,0])cylinder(d=44,h=36); //fits better but hole in outer wall
    translate([0,-26.5-bsl,0])scale([1,1,34/43])rotate([-90,0,0])cylinder(d=43,h=36);
    translate([44.5,-22.5,0])cylinder(d=33,h=41,center=true);
    translate([44.5,-26.5-41/2,0]) cube([41,41,41],center=true);
    translate([44.5,-22.5-4,0])cube([18,30,43.5],center=true);
    translate([44.5,-22.5,0])rotate([-25,90,0]) hull() {
      cylinder(d=29,h=37.5/2+bsl);
      translate([0,-40,0])cylinder(d=29,h=37.5/2+bsl);
    }
  }  
}
difference() {
  union() {
    brakeless();
    intersection() {
      path_sweep(circle(r=5),path_join([path2,path3]));
      cylinder(d=49,h=10,center=true);
    }
  }
    intersection() {
      path_sweep(keyhole(50,3,3,spin=90),path2);
      path_sweep(keyhole(50,3,3,spin=-90),[[15,40,0],[14,1.5,0]]);
      }
    path_sweep(circle(1),[[15,-10,0],[14,10,0]]);
}