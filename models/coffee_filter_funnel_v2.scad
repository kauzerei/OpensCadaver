//Funnel for coffee filters
//To filter chemicals directly into bottles
//Newer geometrically correct version
//To be printed in vase mode (outer shell only)
include <../import/BOSL2/std.scad>
pi=355/113;
l=55; //lower seam length
d=125; //opening diameter
s=115; //side seam length
wi=0.2; //minimal width of inner teeth
wo=1; //minimal width of outer teeth
r0=1; //defines funnel opening at filter base
step=1; //now often new cross section profile is generated
h=sqrt(pow(s,2)-pow(d/2-l/2,2));
w=5; //distance between teeth
db=20; //bottle diameter
tl=40; //lower tube length

//gives coordinates on the oval shape given radius and straight part length and parameter t
//parameter t is length along the shape to a point from the middle of the straight segment
function oval(r,l,t)=t<l/2?[t,r]
                           :t<l/2+r*pi?[l/2,0]+[r*sin(180*(t-l/2)/(pi*r)),r*cos(180*(t-l/2)/(pi*r))]
                           :t<1.5*l +r*pi?[-(t-l-r*pi),-r]
                           :t<1.5*l+2*r*pi?[-l/2,0]+[-r*sin(180*(t-1.5*l-pi*r)/(pi*r)),-r*cos(180*(t-1.5*l-pi*r)/(pi*r))]
                           :[t-(2*l+2*r*pi),r];

//total length of the oval, useful for parametrization: calling oval with t from 0 to total gives all points of the oval
function total(r,l)=2*l+2*r*pi;

//shape of a unit 1x1 tooth, pi is the inner tip width, po is the outer tip width
//x=0 is single tooth, x=0.5 two teeth, inbetween x values give smooth bledning on teeth doubling
function tooth(x,pi,po)=x<pi+po?[[0,0],
                                 [pi/2,0],
                                 each [for (i=[0:1:5]) [0.5-x/2-po/2+(x+po)*0.2*i,1]],
                                 [1-pi/2,0]]
                               :[[0,0],
                                 [pi/2,0],
                                 [0.5-x/2-po/2,1], 
                                 [0.5-x/2+po/2,1],
                                 [0.5-pi/2,(1-2*x)/(1-x-pi-po)],
                                 [0.5+pi/2,(1-2*x)/(1-x-pi-po)],
                                 [0.5+x/2-po/2,1],
                                 [0.5+x/2+po/2,1],
                                 [1-pi/2,0]];

//array of n teeth, outputs tuples of parameter t and degree of outward expansion of the curve
//x is degree of transition between single and double grooves 0 to 0.5, n is number of grooves on curve
function teeth(x,n,pi,po)=[for (i=[0:1:n-1]) for(t=tooth(x,pi=pi,po=po)) [t[0]+i,t[1]] ];

//generate path from radius, length of straight part, depth of groove, number of grooves, groove pointiness, stage of transition
function path(r,l,d,n,wi,wo,x=0)=let(po=n*wo/total(r+d,l))let(pi=n*wi/total(r,l))[for (i=teeth(x,n,pi,po)) oval(r=r+i[1]*d,l=l,t=i[0]*total(r+i[1]*d,l)/n)];

//define regions of r, l, d values across heights:
rvals=[[-2*w-(l-db)/2-tl,db/2],[-2*w-(l-db)/2,db/2],[-2*w,r0+w],[0,r0],[h,d/2]];
lvals=[[-2*w-(l-db)/2-tl,0],   [-2*w-(l-db)/2,0],   [-2*w,l-2*w], [0,l], [h,0]  ];
dvals=[[-2*w-(l-db)/2-tl,0],   [-2*w-(l-db)/2,0],   [-2*w,0],   [0,w], [h,w]  ];

//calculate optimal number of teeth and height where it doubles, i.e. the path length doubles:
totvals=[for (z=[0:1:h]) total(r=lookup(z,rvals),l=lookup(z,lvals))];
n=floor(0.5*totvals[0]/w)*2+1; //should be odd so teeth don't meet
dbl=[for (i=[0:1:h]) each totvals[i]>=2*totvals[0]?[i]:[]][0];

//define regions of x, z values across heights:
xvals=[[-2*w-(l-db)/2-tl,0],[dbl-2*w,0],[dbl,0.5],[h,0.5]];
zvals=[for (z=[-2*w-(l-db)/2-tl:step:h]) z];
paths=[for (z=zvals) path(r=lookup(z,rvals),l=lookup(z,lvals),d=lookup(z,dvals),n=n,wi=wi,wo=wo,x=lookup(z,xvals))];

//let(lim=34)skin([for (i=[0:1:lim]) paths[i]], slices=0, z=[for (i=[0:1:lim]) zvals[i]], refine=1, sampling="segment",method="direct");
mirror([0,0,1])skin(paths, slices=0, z=zvals, refine=1, sampling="segment",method="direct");
