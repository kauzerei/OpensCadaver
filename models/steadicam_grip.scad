//Grip specifically developed for metal grip holders on my steadicam replica
//Ugly written, but developing this grip triggered reimplementing Hatch Flow in OpenSCAD
//Rubber is the TPU part you print in surface mode, small is simplified hard plastic holder, it stops grip from rotating. Extended is bigger version of this holder.  
$fa=1/1;
$fs=1/1;
part="tpu";//[tpu,hard_plastic]
if (part=="tpu") tpu();
if (part=="hard_plastic") hard_plastic();
/* Initially this part was generated with Hatch Flow pattern, but experiment show that the softest grip is the one with no flips in pattern at all, which means, I don't have to use computationally-expensive generation, so I remodelled everything with simple circles and twisted linear extrusions. I'll keep the old code in this comment
use <hatch_flow.scad>
part="none";//[small,extended,rubber]
inv=false;
$fn=64/1;
if (part=="rubber") ring(nhor=12,nvert=9,hvert=100,ndepth=1,od=33,id=22);
else if (part=="small") {
  intersection() {
    rotate([0,0,-13]) difference() {
      cylinder(h=8,d=26);
      translate([0,0,-0.01])cylinder(h=8.02,d=23);
    }
    translate([0,-8,0]) cube([33,16,12]);
  }
  translate([0,0,8])for (u=[-15:30:50]) rotate([0,0,u]) linear_extrude(height=4,twist=-10)translate([12,-3])rotate(27)square([2,5],center=true);
}
else if(part=="extended") {
  
  difference() {
    union() {
      cylinder(d=24,h=8);
      translate([0,0,inv?8:0])rotate([inv?180:0,0,0])fins(h=8,s=-0.5);
      translate([0,0,8]) intersection(){
        cylinder(h=8,d=26);
        translate([-17,-8,0]) cube([34,16,12]);      
      }
    }
  translate([0,0,-0.01])cylinder(d=23,h=16.02);
  }
}
module cutouts() {
  for (i=[0:1:11]) element(amin=i*30,amax=(i+1)*30,rmin=11,rmax=16.5,zmin=0,zmax=0+100/9);
}
//fins(h=11,s=-0.5);
module fins(h=11,s=0.5) linear_extrude(twist=-2.7*h,height=h,convexity=10)offset(r=s)projection(cut=true)cutouts();
*/
module onetooth(id=22,od=32,w=5) { //2d shape of horizontal cut through one tooth
  intersection() {
    translate([id/2,0]) difference() {
      circle(d=id+w);
      circle(d=id);
      translate([-od/2,0]) square([od,od]);
      }
    difference(){
      circle(d=od);
      circle(d=id);
    }
  }
}
module slice(id=27,od=32, w=6,n=12) for (a=[0:360/n:360-360/n]) rotate(a) onetooth(id=id,od=od,w=w); //2d horizontal cut of the whole spiral
module spiral(id=27,od=32, w=6,n=12,h=100,t=-2.7) //the whole spiral
  linear_extrude(height=h,twist=h*t)slice(id=id,od=od,w=w,n=n);
  
module cross(w=10,d=26,n=5,h=10) { //Not used. I thought I'd use such coupling to hard plastic ends of the grip.
  for (a=[0:360/n:360-360/n]) rotate([0,0,a]) 
    linear_extrude(height=h,scale=(0.8))translate([-w/2,0])square([w,d/2]);
}
module tpu() { //the rubbery part of the grip. Print in surface mode, no retraction and spiralized for best results
  cylinder(d=27,h=100);
  spiral();
}

module hard_plastic() { //the part that goes under rubber. Generated for surface mode spiralized, with supports built in model. 
  difference() {
    union() {
      intersection(){
        cylinder(d=26,h=8);
        translate([-17,-8,0])cube([34,16,12]);
      }
      translate([0,0,108])intersection(){
        cylinder(d=26,h=8);
        translate([-17,-8,0])cube([34,16,12]);
      }
      translate([0,0,8]) {
        cylinder(d=26,h=100);
        spiral(id=26,od=29,w=3);  
      }
    }
    translate([0,0,-0.01])cylinder(h=116.02,d=25);
    translate([0,0,8])linear_extrude(height=108,twist=-2.7*108,convexity=10)rotate(5)translate([9,-0.2])square([10,0.4]);
  }
translate([-13,0,0])cube([26,1,8]);
translate([-7,-14,0])cube([2,28,8]);
translate([-1,-15,0])cube([2,30,8]);
translate([-4,-15,0])cube([2,30,8]);
translate([2,-15,0])cube([2,30,8]);
translate([5,-14,0])cube([2,28,8]);
translate([-7,-10,0])cube([14,20,8]);
translate([-13,0,108])cube([26,1,8]);
}