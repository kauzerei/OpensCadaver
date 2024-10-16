include <BOSL2/std.scad>
top_d=130;
bottom_d=55;
//bottom_length=50;
bottleneck=25;
tube=30;
height=90;
grooves_depth=5;
grooves_distance=5;
transition=10;
steps=ceil(log(top_d/bottom_d)/log(2))+1;
n=ceil(bottom_d*PI/(grooves_distance));
h0=height/(2^steps-1);
zvals=[0, for (i=[1:steps-1]) each [h0*(2^i-1)-transition/2, h0*(2^i-1)+transition/2], height];
//echo (zvals);
star_ns=[for (j=[0:0.5:steps-0.5], i=floor(j)) n*2^i];
//echo(star_ns[5]);
//function r(h)=(1-1/height)*top_d/2+(1/height)*bottom_d/2;
function r(h)=bottom_d/2+h*(top_d-bottom_d)/(2*height);
rs=[for(i=[0:steps*2-1]) r(i)];
//scales=[for (i=[0:steps*2-1]) bottleneck/bottom_d+i*(1-bottleneck/bottom_d)/(2*steps-1)];
//echo(scales);
//echo(r(zvals[0]));
//stars=[for (i=[0:steps*2-1]) xscale(scales[i],rot(180/star_ns[i],p=star(n=star_ns[i],r=r(zvals[i])+grooves_depth/2,ir=r(zvals[i])-grooves_depth/2)))];
stars=[for (i=[0:steps*2-1]) rot(180/star_ns[i],p=star(n=star_ns[i],r=r(zvals[i])+grooves_depth/2,ir=r(zvals[i])-grooves_depth/2))];
//star(n=n*2^i,r=2^i*bottom_d/2-grooves_depth/2,ir=2^i*bottom_d/2+grooves_depth/2)];
//echo(star_ns);
skin(stars,z=zvals,slices=2, refine=2, method="fast_distance");
//skin(stars,z=zvals,slices=2, refine=2, method="direct");
skin([circle(bottleneck/2),circle(bottleneck/2),stars[0]],z=[-tube-transition,-transition,0],slices=4, refine=4, method="reindex");
/*translate([-20,0,0])skin([star(n=n,r=20,ir=10), star(n=2*n,r=100,ir=90)], z=[0,100], slices=20);
translate([20,0,0])skin([star(n=20,r=20,ir=10), star(n=40,r=100,ir=90)], z=[0,100], slices=20);
hull() {
  translate([-20,0,0]) sphere(r=20);
  translate([20,0,0]) sphere(r=20);
}
*/
//echo(n);
//echo(steps);
*for (r=[0,180])rotate([0,0,r])translate([0,bottom_length/2,0])back_half(s=300) {
for (i=[0:steps-1]) {
r0=2^i*bottom_d/2;
r1=2*r0;
translate([0,0,0])skin([star(n=n*2^i,r=r0,ir=r0-grooves_depth), star(n=2*n*2^i,r=r1,ir=r1-grooves_depth)], z=[h0*(2^i-1),h0*(2^(i+1)-1)], slices=20);
}
}