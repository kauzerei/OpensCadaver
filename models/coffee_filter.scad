include <BOSL2/std.scad>
top_d=150;
bottom_d=20;
bottom_length=50;
bottleneck=15;
height=100;
grooves_depth=5;
grooves_distance=5;
steps=ceil(log(top_d/bottom_d)/log(2));
n=2*floor(bottom_d*PI/(2*grooves_distance))+1;
/*translate([-20,0,0])skin([star(n=n,r=20,ir=10), star(n=2*n,r=100,ir=90)], z=[0,100], slices=20);
translate([20,0,0])skin([star(n=20,r=20,ir=10), star(n=40,r=100,ir=90)], z=[0,100], slices=20);
hull() {
  translate([-20,0,0]) sphere(r=20);
  translate([20,0,0]) sphere(r=20);
}
*/
echo(n);
h0=height/(2^steps-1);
for (r=[0,180])rotate([0,0,r])translate([0,bottom_length/2,0])back_half(s=300) {
for (i=[0:steps-1]) {
r0=2^i*bottom_d/2;
r1=2*r0;
translate([0,0,0])skin([star(n=n*2^i,r=r0,ir=r0-grooves_depth), star(n=2*n*2^i,r=r1,ir=r1-grooves_depth)], z=[h0*(2^i-1),h0*(2^(i+1)-1)], slices=20);
}
}