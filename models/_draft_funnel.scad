include <../import/BOSL2/std.scad>
top=130;
bot=40;
tube=20;
length=30;
height=100;
groove=5;
dist=5;
transition=15;
//function r(h)=bot/2+(top/2-bot/2)*(h/height); //h(r)=height*(r-bot/2)/(top/2-bot/2)
//function n(r)=floor(2*r*PI/distance); //r(n)=n*distance/(2*PI);
//function h(n)=height*(n*distance/(2*PI)-bot/2)/(top/2-bot/2); //=h(r(n))
//begin=n(bot/2);
//end=n(top/2);
//stars=[for(i=[begin:end]) star(n=i,r=r(h(i))+distance,ir=r(h(i)))];
//zvals=[for(i=[begin:end]) h(i)];

//skin(stars,z=zvals,slices=2,refine=2,method="reindex");
//skin(stars,z=zvals,slices=0,refine=1,method="fast_distance");
//zvals=[0,10,20,40,80,100];

//zvals=[for (i=[0:3]) h(n(2^i*bot/2))];
//stars=[for (z=zvals) star (n=n(r(z)),r=r(z)+groove,ir=r(z))];

//skin(stars,z=zvals,slices=0,refine=1,method="fast_distance");

hull() {
  cylinder(d1=tube-2*groove,d2=top,h=height);
  translate([0,bot/2,0])cylinder(d=tube-2*groove);
  translate([0,-bot/2,0])cylinder(d=tube-2*groove);
}
hull() {
  translate([0,0,-bot/2])cylinder(d=tube-2*groove);
  translate([0,bot/2,0])cylinder(d=tube-2*groove);
  translate([0,-bot/2])cylinder(d=tube-2*groove);
}
translate([0,0,-length])cylinder(d=tube,h=height);


 /*
path = circle(d=top_d);
tx=texture([[10,0],[1,0]]);
texture = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1],
    [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1],
    [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1],
    [0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
];
linear_sweep(
    path, texture=texture, scale=bottleneck/top_d,shift=[bottom_d/2,0],tex_size=[grooves_distance,height],tex_depth=grooves_depth,
    style="quincunx",h=height);
linear_sweep(
    path, texture=texture, scale=bottleneck/top_d,shift=[-bottom_d/2,0],tex_size=[grooves_distance,height],tex_depth=grooves_depth,
    style="quincunx",h=height);*/
/*steps=ceil(log(top_d/bottom_d)/log(2));
n=ceil(bottom_d*PI/(grooves_distance));
h0=height/(2^steps-1);
zvals=[0, for (i=[1:steps-1]) each [h0*(2^i-1)-transition/2, h0*(2^i-1)+transition/2], height];
star_ns=[for (j=[0:0.5:steps-0.5], i=floor(j)) n*2^i];
function r(h)=bottom_d/2+h*(top_d-bottom_d)/(2*height);
rs=[for(i=[0:steps*2-1]) r(i)];
stars=[for (i=[0:steps*2-1]) rot(180/star_ns[i],p=star(n=star_ns[i],r=r(zvals[i])+grooves_depth/2,ir=r(zvals[i])-grooves_depth/2))];
skin(stars,z=zvals,slices=2,refine=2, method="fast_distance");
skin([circle(bottleneck/2),circle(bottleneck/2),stars[0]],z=[-tube-transition,-transition,0],slices=4, refine=4, method="reindex");*/