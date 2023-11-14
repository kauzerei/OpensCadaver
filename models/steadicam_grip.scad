//Grip specifically developed for metal grip holders on my steadicam replica
//Not really parametric, but developing this grip triggered reimplementing Hatch Flow in OpenSCAD
use <hatch_flow.scad>
part="rubber";//[rubber,plastic]
$fn=64;
if (part=="rubber") ring(nhor=12,nvert=9,hvert=100,ndepth=1,od=33,id=22);
else if (part=="plastic") {
  intersection() {
    rotate([0,0,-13]) difference() {
      cylinder(h=8,d=26);
      translate([0,0,-0.01])cylinder(h=8.02,d=23);
    }
    translate([0,-8,0]) cube([33,16,12]);
  }
  translate([0,0,8])for (u=[-15:30:50]) rotate([0,0,u]) linear_extrude(height=4,twist=-10)translate([12,-3])rotate(27)square([2,5],center=true);
}
module cutouts() {
  for (i=[-1.5:1:1.5]) element(amin=i*30,amax=(i+1)*30,rmin=11,rmax=16.5,zmin=8,zmax=8+100/9);
}