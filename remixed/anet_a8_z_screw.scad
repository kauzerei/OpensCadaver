include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
part="screw_holder";//[counternut,pusher,switch_offset,screw_holder]
if (part=="counternut") render() difference() {
  cyl(h=6, d=20, texture="ribs", tex_size=[2,5],tex_depth=1);
  cylinder(h=7,d=3.7,center=true);
}
if (part=="pusher") render() difference() {
  cyl(h=10, d=20, texture="ribs", tex_size=[2,1],tex_depth=1,tex_taper=0);
  up(3) cylinder(h=10,d=3,center=true);
}
if (part=="switch_offset") {
  linear_extrude(height=5) difference() {
    polygon(round_corners(rect([14,25],chamfer=[0,0,0,9]),radius=[0,0,5,5,0]));
    translate([-3,7.5]) circle(d=3.5);
    translate([-3,-7.5]) circle(d=3.5);
  }
  translate([2,-1.5,0]) cube([5,14,16]);
  difference() {
    translate([2,0.5,0]) cube([5,12,40]);
    translate([6,9,24.5])xcyl(d=3,h=10);
    translate([6,9,34.5])xcyl(d=3,h=10);
  }
}
if(part=="screw_holder") {
  difference() {
    linear_extrude(height=5,convexity=3) difference() {
      square([46,18]);
      translate([46/2,18/2+20]) circle(r=18);
      translate([46/2-15.5,18/2+20-15.5]) circle(d=3.5);
      translate([46/2+15.5,18/2+20-15.5]) circle(d=3.5);
    }
  translate([46/2-15.5,18/2+20-15.5,3.1]) cylinder(d1=3,d2=6,h=2);
  translate([46/2+15.5,18/2+20-15.5,3.1]) cylinder(d1=3,d2=6,h=2);
  }
  difference() {
    translate([-6,8,0]) cube([10,10,19]);
    translate([-1,13,14]) xcyl(d=4,h=12);
  }
}