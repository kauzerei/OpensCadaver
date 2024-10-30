//Funnel for coffee filters
//To filter chemicals directly into bottles
//To be printed in vase mode (outer shell only)
include <../import/BOSL2/std.scad>
top_d=130;
bottom_d=40;
bottleneck=20;
tube=30;
height=100;
grooves_depth=5;
grooves_distance=5;
transition=15;
steps=ceil(log(top_d/bottom_d)/log(2));
n=ceil(bottom_d*PI/(grooves_distance));
h0=height/(2^steps-1);
zvals=[0, 
       for (i=[1:steps-1]) each [h0*(2^i-1)-transition/2, h0*(2^i-1)+transition/2],
       height];
star_ns=[for (j=[0:0.5:steps-0.5], i=floor(j)) n*2^i];
function r(h)=bottom_d/2+h*(top_d-bottom_d)/(2*height);
rs=[for(i=[0:steps*2-1]) r(i)];
stars=[
  for (i=[0:steps*2-1]) rot(180/star_ns[i],
                            p=star(n=star_ns[i],
                            r=r(zvals[i])+grooves_depth/2,
                            ir=r(zvals[i])-grooves_depth/2))
];
skin(stars,z=zvals,slices=2,refine=2, method="fast_distance");
skin([circle(bottleneck/2),circle(bottleneck/2),stars[0]],
     z=[-tube-transition,-transition,0],
     slices=4,
     refine=4,
     method="reindex");