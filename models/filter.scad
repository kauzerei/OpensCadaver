pi=3.1415926;
include <../import/BOSL2/std.scad>
l=50; //lower seam length
d=150; //opening diameter
s=120; //side seam length
h=sqrt(pow(s,2)-pow(d/2-l/2,2));
w=4; //distance between teeth
h0=1; //starting height of filter holder
db=20; //bottle diameter
tube_length=40;

//oval ranges
//0 - l/2 - half line
//l/2 - l/2 + r*pi - first arc
//l/2 + r*pi - 1.5*l +r*pi - straight line
//1.5*l + r*pi - 1.5*l + 2*r*pi - second arc
//1.5*l + 2*r*pi - 2*l + 2*r*pi last half

function coordinates(r,l,t)=t<l/2?[t,r]
                           :t<l/2+r*pi?[l/2,0]+[r*sin(180*(t-l/2)/(pi*r)),r*cos(180*(t-l/2)/(pi*r))]
                           :t<1.5*l +r*pi?[-(t-l-r*pi),-r]
                           :t<1.5*l+2*r*pi?[-l/2,0]+[-r*sin(180*(t-1.5*l-pi*r)/(pi*r)),-r*cos(180*(t-1.5*l-pi*r)/(pi*r))]
                           :[t-(2*l+2*r*pi),r];

function total(r,l)=2*l+2*r*pi;

function toothed_shape(r,l,d,n)=[for (i=[0:1:n-1]) each [coordinates(r,l,i*total(r,l)/n),coordinates(r+d,l,(i+0.5)*total(r+d,l)/n)]];

function params(z)=[z*0.5*d/h,(h-z)*l/h];

function ns(z)=floor(total(params(z)[0],params(z)[1])/w);

function findnext(list)=[list[0],for (i=[1:1:len(list)-1]) each ns(list[i])==2*ns(list[0])&&ns(list[i-1])<2*ns(list[0])?findnext([for (j=[i:1:len(list)-1]) list[j]]):[]];

unfiltered_zvals=[for (z=[h0:1:h]) z];
filtered_zvals=[each findnext(unfiltered_zvals), unfiltered_zvals[len(unfiltered_zvals)-1]];
zvals=[filtered_zvals[0],each [for (i=[1:1:len(filtered_zvals)-2]) each [filtered_zvals[i]-2*w,filtered_zvals[i]]],filtered_zvals[len(filtered_zvals)-1]];
nvals=[for (z=filtered_zvals) each [ns(z),ns(z)]];
paths=[ for (i=[0:len(zvals)-1]) toothed_shape(params(zvals[i])[0],params(zvals[i])[1],w,nvals[i])];
mirror([0,0,1]) {
  skin(paths, slices=2, z=[for (i=[0:1:len(paths)-1]) zvals[i] ], refine=2, method="fast_distance");
  //skin([paths[0],paths[1]], slices=1, z=[zvals[0],zvals[1]], refine=1, method="fast_distance"); //testing purposes
  skin([toothed_shape(params(zvals[0])[0]+w,params(zvals[0])[1]-2*w,0,nvals[0]), paths[0]], slices=2, z=[-2*w, zvals[0] ], refine=2, method="fast_distance");
  hull() {
    translate([0,0,-2*w-(l-db)/2]) scale([1,1,0]) cylinder(d=db,h=1,$fn=64);
    translate([0,0,-2*w]) scale([1,1,0]) linear_extrude(1) polygon(toothed_shape(params(zvals[0])[0]+w,params(zvals[0])[1]-2*w,0,4*nvals[0]));
  }
  translate([0,0,-2*w-(l-db)/2]) mirror([0,0,1]) cylinder(d=db,h=tube_length,$fn=64);
}