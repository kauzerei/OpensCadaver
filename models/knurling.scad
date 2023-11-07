n=60;
d=30;
h=20;
a=45;
depth=0.5;
precision=1.0;

module knurl(n=60,d=30,h=20,a=45,depth=1,precision=1) {
  pi=3.14159/1.0;
  twist=tan(a)*360*h/(d*pi);
    if(abs(a)==90) {
      l=d*pi/n;
      intersection() {
        for (s=[0:l:h]) {
          translate([0,0,s])cylinder(d1=d,d2=d-2*depth,h=l/2,$fa=1,$fs=precision);
          translate([0,0,s+l/2])cylinder(d2=d,d1=d-2*depth,h=l/2,$fa=1,$fs=precision);
        }
      cylinder(d=d,h=h,$fa=1,$fs=precision);
      }
    }
  else {
    t=[for (i=[0:2*n-1]) [sin(i*180/n)*(i%2==0?d/2:d/2-depth),cos(i*180/n)*(i%2==0?d/2:d/2-depth)]];
    linear_extrude(height=h,twist=twist,convexity=10,$fa=1,$fs=precision) polygon(t);
  }
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
perpendicular_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
//cross_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision);
//cross_knurl();