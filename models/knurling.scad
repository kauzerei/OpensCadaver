//Short and mostly efficient modules that produce different types of knurling
//I've written it before learning about BOSL2, it's pathetic in comparison
n=60;
d=30;
h=20;
a=45;
depth=0.5;
fraction=2;
precision=1.0;

module knurl(n=60,d=30,h=20,a=45,depth=1,precision=1,fraction=2) {
  pi=3.14159/1.0;
  twist=tan(a)*360*h/(d*pi);
  if(abs(a)==90) {
    l=d*pi/n;
    intersection() {
      for (s=[0:l:h]) {
        translate([0,0,s])cylinder(d1=d,d2=d-2*depth,h=l/fraction,$fa=1,$fs=precision);
        translate([0,0,s+l/fraction])cylinder(d2=d,d1=d-2*depth,h=l/fraction,$fa=1,$fs=precision);
        translate([0,0,s+2*l/fraction])cylinder(d=d,h=l*(1-2/fraction),$fa=1,$fs=precision);
      }
    cylinder(d=d,h=h,$fa=1,$fs=precision);
    }
  }
  else {
    t=[for (i=[0:fraction*n-1]) [sin(i*360/(n*fraction))*(i%fraction==0?d/2-depth:d/2),cos(i*360/(n*fraction))*(i%fraction==0?d/2-depth:d/2)]];
    linear_extrude(height=h,twist=twist,convexity=10,$fa=1,$fs=precision) polygon(t);
  }
}
module cross_knurl(n=60,d=30,h=20,a=45,depth=1,precision=1,fraction=2) {
  intersection() {
    knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision,fraction=fraction);
    knurl(n=n,d=d,h=h,a=-a,depth=depth,precision=precision,fraction=fraction);
  }
}
module perpendicular_knurl(n=60,d=30,h=20,a=45,depth=1,precision=1,fraction=2) {
  intersection() {
    knurl(n=abs(a)==90?n:floor(n*cos(a)),d=d,h=h,a=a,depth=depth,precision=precision,fraction=fraction);
    knurl(n=abs(a-90)==90?n:floor(n*cos(a-90)),d=d,h=h,a=a-90,depth=depth,precision=precision,fraction=fraction);
  }
}

//knurl(n=floor(n*cos(a)),d=d,h=h,a=a,depth=depth,precision=precision,fraction=fraction);
perpendicular_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision,fraction=fraction);
//cross_knurl(n=n,d=d,h=h,a=a,depth=depth,precision=precision,fraction=fraction);
//cross_knurl();
