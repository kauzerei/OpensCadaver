//Funnel for coffee filters
//To filter chemicals directly into bottles
//Newer geometrically correct version
//To be printed in vase mode (outer shell only)
include <../import/BOSL2/std.scad>
pi=355/113;
l=55; //lower seam length
d=125; //opening diameter
s=115; //side seam length
mw=1; //minimal width of the sharp part
h0=1; //starting height of filter holder
step=2; //now often new cross section profile is generated
h=sqrt(pow(s,2)-pow(d/2-l/2,2));
w=5.2; //distance between teeth
db=20; //bottle diameter
tl=40; //lower tube length

//oval ranges
//0 - l/2 - half line
//l/2 - l/2 + r*pi - first arc
//l/2 + r*pi - 1.5*l +r*pi - straight line
//1.5*l + r*pi - 1.5*l + 2*r*pi - second arc
//1.5*l + 2*r*pi - 2*l + 2*r*pi last half

//gives coordinates on the oval shape given radius and straight part length and parameter t
//parameter t is length along the shape to a point from the middle of the straight segment
function oval(r,l,t)=t<l/2?[t,r]
                           :t<l/2+r*pi?[l/2,0]+[r*sin(180*(t-l/2)/(pi*r)),r*cos(180*(t-l/2)/(pi*r))]
                           :t<1.5*l +r*pi?[-(t-l-r*pi),-r]
                           :t<1.5*l+2*r*pi?[-l/2,0]+[-r*sin(180*(t-1.5*l-pi*r)/(pi*r)),-r*cos(180*(t-1.5*l-pi*r)/(pi*r))]
                           :[t-(2*l+2*r*pi),r];

 //total length of the oval, useful for parametrization: t from 0 to total gives all points of the oval
function total(r,l)=2*l+2*r*pi;

//shape of a unit tooth p is the tip width
//x=0 is single tooth, x=0.5 two teeth, inbetween x values give smooth bledning on teeth doubling
function tooth(x,p=1)=x<2*p?[[0,0],
                                            [p/2,0],
                                            each [for (i=[0.5-x/2-p/2:(x+p)/4:0.5+x/2+p/2]) [i,1]],
                                            [0.5+x/2+p/2,1],
                                            [1-p/2,0]]
                                           :[[0,0],
                                            [p/2,0],
                                            [0.5-x/2-p/2,1],
                                            [0.5-x/2+p/2,1], //error
                                            [0.5-p/2,(1-2*x)/(1-x-2*p)],
                                            [0.5+p/2,(1-2*x)/(1-x-2*p)],
                                            [0.5+x/2-p/2,1],
                                            [0.5+x/2+p/2,1],
                                            [1-p/2,0]];

//array of n teeth, outputs tuples of parameter t and degree of r expansion
function teeth(x,n,p=1)=[for (i=[0:1:n-1]) for(t=tooth(x,p)) [t[0]+i,t[1]] ];

//generate path from radius, length of straight part, number of teeth, minimal groove pointiness, stage of transition
function path(r,l,d,n,mw=0.8,x=0)=let(p=n*mw/total(r+d,l))[for (i=teeth(x,n,p)) oval(r=r+i[1]*d,l=l,t=i[0]*total(r+i[1]*d,l)/n)];

//params to pass into cross_section: namely r and h
function params(z)=[z*0.5*d/h,(h-z)*l/h];

//number of teeth, optimal for certain height
function nt(z)=floor(total(params(z)[0],params(z)[1])/w);

//height where the optimal number of teeth doubles in comparison with h0
dbl=[for (i=[h0:step:h]) each nt(i)>=2*nt(h0)?[i]:[]][0];

//regions of r, l, d, x values across heights:
//rvals=[[h0-2*w-(l-db)/2-tl,db/2],[h0-2*w-(l-db)/2,db/2],[h0-2*w,params(h0)[0]+2*w],[h0,params(h0)[0]],[h,params(h0)[0]]];
rvals=[[h0-2*w-(l-db)/2-tl,db/2],[h0-2*w-(l-db)/2,db/2],[h0-2*w,w],[h0,w],[h,d/2]];
//lvals=[[h0-2*w-(l-db)/2-tl,0],   [h0-2*w-(l-db)/2,0],   [h0-2*w,params(h0)[1]+2*w],[h0,params(h0)[1]],[h,params(h0)[1]]];
lvals=[[h0-2*w-(l-db)/2-tl,0],   [h0-2*w-(l-db)/2,0],   [h0-2*w,l],[h0,l],[h,0]];
dvals=[[h0-2*w-(l-db)/2-tl,0],   [h0-2*w-(l-db)/2,0],   [h0-2*w,0],[h0,w],[h,w]];
xvals=[[h0-2*w-(l-db)/2-tl,0],                    [dbl-2*w,0],[dbl,0.5],[h,0.5]];
zvals=[for (z=[h0-2*w-(l-db)/2-tl:step:h]) z];
paths=[for (z=zvals) path(r=lookup(z,rvals),l=lookup(z,lvals),d=lookup(z,dvals),n=nt(h0),mw=mw,x=lookup(z,xvals))];
//let(lim=10)skin([for (i=[0:1:lim]) paths[i]], slices=0, z=[for (i=[0:1:lim]) zvals[i]], refine=1, sampling="segment",method="direct");
skin(paths, slices=0, z=zvals, refine=1, sampling="segment",method="direct");

/*
function findnext(list)=[list[0],for (i=[1:1:len(list)-1]) each ns(list[i])==2*ns(list[0])&&ns(list[i-1])<2*ns(list[0])?findnext([for (j=[i:1:len(list)-1]) list[j]]):[]];




profiles=

/*unfiltered_zvals=[for (z=[h0:1:h]) z];
filtered_zvals=[each findnext(unfiltered_zvals), unfiltered_zvals[len(unfiltered_zvals)-1]];
zvals=[filtered_zvals[0],each [for (i=[1:1:len(filtered_zvals)-2]) each [filtered_zvals[i]-2*w,filtered_zvals[i]]],filtered_zvals[len(filtered_zvals)-1]];
nvals=[for (z=filtered_zvals) each [ns(z),ns(z)]];
paths=[ for (i=[0:len(zvals)-1]) toothed_shape(params(zvals[i])[0],params(zvals[i])[1],w,nvals[i])];
mirror([0,0,1]) {
  skin(paths, slices=10, z=[for (i=[0:1:len(paths)-1]) zvals[i] ], refine=1, sampling="segment",method="direct");
  skin([toothed_shape(params(zvals[0])[0]+w,params(zvals[0])[1]-2*w,0,nvals[0]), paths[0]], slices=10, z=[h0-2*w, zvals[0] ], refine=1, sampling="segment",method="direct");
  //skin([paths[0],paths[1]], slices=0, z=[for (i=[0:1]) zvals[i] ], refine=1, sampling="segment",method="fast_distance");
  //skin([toothed_shape(params(zvals[0])[0]+w,params(zvals[0])[1]-2*w,0,nvals[0]), paths[0]], slices=10, z=[h0-2*w, zvals[0] ], refine=4, sampling="segment",method="fast_distance");
  hull() {
    translate([0,0,h0-2*w-(l-db)/2]) scale([1,1,0]) cylinder(d=db,h=1,$fn=64);
    translate([0,0,h0-2*w]) scale([1,1,0]) linear_extrude(1) polygon(toothed_shape(params(zvals[0])[0]+w,params(zvals[0])[1]-2*w,0,nvals[0]));
  }
  translate([0,0,h0-2*w-(l-db)/2]) mirror([0,0,1]) cylinder(d=db,h=tube_length,$fn=64);
}
*/