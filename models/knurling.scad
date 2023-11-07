/*n=60;
d=30;
h=20;
a=45;
depth=0.1;
precision=1.0;
*/
module knurl(n=60,d=30,h=20,a=45,depth=1,precision=1) {
  pi=3.14159/1.0;
  t=[for (i=[0:n-1]) [sin(i*360/n)*(i%2==0?d/2:d/2-depth),cos(i*360/n)*(i%2==0?d/2:d/2-depth)]];
  linear_extrude(h,twist=pi*a*h/d,convexity=10,$fa=1,$fs=precision) polygon(t);
}
module cross_knurl(n=60,d=30,h=20,a=45,depth=1,precision=1) {
  intersection() {
    knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
    knurl(n=n,d=d,h=h,a=-a,depth=depth,precision=precision);
  }
}

//knurl(n=n,d=d,h=h,a=a,depth=depth);
//cross_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
cross_knurl();