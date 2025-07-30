include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fn=32;

width=10;
p=[[0,0],[0,70],[12,71],[24,65]];
w=[4,4,4,4]; //widths of links
l=[2,2,2,2]; //lengths of joints
t=[1,1,1,1]; //thicknesses of joints
tg=path_tangents(p,closed=true,uniform=false);

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
//key height screw

//key height stop


for (i=[0:1:len(p)-1]) stroke(joints[i],width=t[i]);
for (i=[0:1:len(p)-1]) stroke(links[i],width=w[i]);