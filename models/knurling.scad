n=60;
d=30;
h=20;
a=45;
depth=0.5;
precision=1.0;

module knurl(n=60,d=30,h=20,a=45,depth=1,precision=1) {
  pi=3.14159/1.0;
  twist=tan(a)*360*h/(d*pi);
  echo(twist);
  t=[for (i=[0:2*n-1]) [sin(i*180/n)*(i%2==0?d/2:d/2-depth),cos(i*180/n)*(i%2==0?d/2:d/2-depth)]];
  linear_extrude(height=h,twist=twist,convexity=10,$fa=1,$fs=precision) polygon(t);
}
module cross_knurl(n=60,d=30,h=20,a=45,depth=1,precision=1) {
  intersection() {
    knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
    knurl(n=n,d=d,h=h,a=-a,depth=depth,precision=precision);
  }
}
module perpendicular_knurl(n=60,d=30,h=20,a=45,depth=1,precision=1) {
  intersection() {
    knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
    knurl(n=n,d=d,h=h,a=a-90,depth=depth,precision=precision);
  }
}

//knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
//perpendicular_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
cross_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
//cross_knurl();  
//distance horizontal between two lines= d*pi/n
//to find the instrument angle from d,n,h and twist we calculate at which height polygon twists 360/n degrees. Given known twist at height of h, twist/h=how much twist in unit of height. at height of l, twist is l*twist/h. To find at which l the twist is 360/n, solve
//l*twist/h=360/n, l=360*h/(n*twist)
//angle between vertical and lines is tan(a)=horizontal shift/vertical shift, tan(a)=(d*pi/n)/(360*h/(n*twist))=d*pi*n*twist/(n*360*h)
//tan a=d*pi*twist/(360*h)
//twist=tan(a)*360*h/(d*pi)