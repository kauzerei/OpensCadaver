include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
p=[[0,0],[0,50],[100,-50],[50,-50]];
w=[5,5,5,5]; //widths of links
l=[1,1,1,1]; //lengths of joints
t=[2,2,2,2]; //thicknesses of joints
tg=path_tangents(p,closed=true,uniform=false);
for (i=[0:1:len(p)-1]) stroke([
  p[i]-0.5*tg[i]*(l[i]+w[(i-1+len(p))%len(p)]),
  p[i]+0.5*tg[i]*(l[i]+w[i])
], width=t[i]);
for (i=[0:1:len(p)-1]) stroke([
  p[i]+0.5*tg[i]*(l[i]+w[(i)%len(p)]),
  p[(i+1)%len(p)]-0.5*tg[(i+1)%len(p)]*(l[(i+1)%len(p)]+w[i])
],width=w[i]);