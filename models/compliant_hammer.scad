include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
include <../import/BOSL2/fnliterals.scad>
$fn=32;

width=10;
p=[[0,0],[-3,70],[5,70],[19,68],[30,61]];
w=[4,4,4,4,4]; //widths of links
l=[2,-4,2,2,2]; //lengths of joints
t=[2,2,2,2,2]; //thicknesses of joints
tg=path_tangents(p,closed=true,uniform=false);

sec_len=[20,80];
sec_wid=[4,4];
sec_stp=[10,10];
stp_pos=[3,3];
sec_ang=15;
fix_ang=-20;
sec_l=2;
sec_t=1;
d=4;
h=1.1*max([each w, each sec_wid]);

//allowing "out of bounds" indices
assert (len(p)==len(w));
assert (len(w)==len(t));
assert (len(p)==len(l));
function p(i)=let(s=len(p)) p[(i+s)%s];
function w(i)=let(s=len(w)) w[(i+s)%s];
function l(i)=let(s=len(l)) l[(i+s)%s];
function t(i)=let(s=len(t)) t[(i+s)%s];
function tg(i)=let(s=len(tg)) tg[(i+s)%s];

joints=[for (i=[0:1:len(p)-1]) [
  p(i)-0.5*tg(i)*(l(i)+w(i-1)),
  p(i)+0.5*tg(i)*(l(i)+w(i))
]];
links=[for (i=[0:1:len(p)-1]) [
  p(i)  +0.5*tg(i)  *(l(i)  +w(i)),
  p(i+1)-0.5*tg(i+1)*(l(i+1)+w(i))
]];

//link-specific features
//link 3
module key_height_screw(i=3) {
angle=atan2((links[i][1]-links[i][0])[0],(links[i][1]-links[3][0])[1]);
translate(mean(links[3])) rotate([0,-90,-angle]) cylinder(d=d,h=h,center=true);
}

//link 4
module key_height_stop(i=4) {
//  echo(line_normal(links[0]));
//angle=atan2((links[3][1]-links[3][0])[0],(links[3][1]-links[3][0])[1]);
proportion=0.9;
//translate(proportion*links[3][0]+(1-proportion)*links[3][1]) rotate([0,-90,-angle]) cylinder(d=4,h=10,center=true);
starting_point=proportion*links[i][0]+(1-proportion)*links[i][1];
feature=[starting_point,starting_point+[-9,10]];
linear_extrude(height=width,center=true) stroke(feature,width=w[i]);
}

//link 0
module base(i=0) {
  linear_extrude(height=width,center=true) {
    stroke([links[i][0],links[i][1]+0.2*(links[i][1]-links[i][0])],width=w[i]);
  }
}

module main() {
  linear_extrude(height=width,center=true,convexity=4) {
    for (i=[0:1:len(p)-1]) stroke(joints[i],width=t[i]);
    for (i=[0:1:len(p)-1]) stroke(links[i],width=w[i]);
  }
}

module secondary() {
  p1=[0,sec_len[0]];
  p2=p1+(sec_wid[0]/2+sec_wid[1]/2+sec_l)*[sin(sec_ang/2),cos(sec_ang/2)];
  p3=p2+sec_len[1]*[sin(sec_ang),cos(sec_ang)];
  p4=p2+stp_pos[1]*[sin(sec_ang),cos(sec_ang)];
  difference() {
    linear_extrude(height=width,center=true,convexity=4) {
      stroke([[0,0],[0,sec_len[0]]],width=sec_wid[0]);
      stroke([[0,sec_len[0]-stp_pos[0]],[sec_stp[0],sec_len[0]-stp_pos[0]]],width=sec_wid[0]);
      stroke([p1,p2],width=sec_t); //maybe hange conecting line shape?
      stroke([p2,p3],width=sec_wid[1]);
      stroke([p4,p4+sec_stp[1]*[cos(sec_ang),-sin(sec_ang)]],width=sec_wid[1]);
      translate(p3) circle(d=30); //hammer efinitely to be changed
    }
    translate(p4+0.7*sec_stp[1]*[cos(sec_ang),-sin(sec_ang)]) rotate([0,-90,-sec_ang-90]) cylinder(d=d,h=h,center=true);
    translate([0,sec_len[0]-stp_pos[0]-6]) rotate([0,-90,0]) cylinder(d=d,h=h,center=true);
  }
}

union() {
  difference() {
    main();
    key_height_screw();
  }
  key_height_stop();
  base();
}
translate(mean(links[2])) rotate([0,0,fix_ang]) secondary();