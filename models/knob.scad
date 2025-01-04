$fs=1/2;
$fa=1/2;
a=9;
b=8;
c=6.1;
d=5.1;
e=2;
module profile(a,b,c,d,e) {
  difference() {
    intersection() {
      circle(d=a);
      translate([-a/2,a/2-b])square([a,b]);
    }
    intersection() {
      circle(d=c);
      translate([-c/2,c/2-d])square([c,d]);
    }
    translate([-e/2,-a])square([e,a]);
  }
}
linear_extrude(height=1) difference(){
  circle(d=17);
  difference() {
    hull() profile(a,b,c,d,e);
    profile(a,b,c,d,e);
  }
}
linear_extrude(height=6.5)profile(a,b,c,d,e);