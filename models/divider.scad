width=1;
w1=66.5;
w2=66;
w3=64;
w4=63.5;
h1=17;
h2=34;
p=[[0,-w1/2],[0,w1/2],[h1,w2/2],[h1,w3/2],[h2,w4/2],[h2,-w4/2],[h1,-w3/2],[h1,-w2/2]];
union() {
  rotate([0,-90,0]) linear_extrude(height=width,center=true) polygon(p);
  intersection() {
    rotate([0,-90,0]) linear_extrude(height=3*width,center=true,convexity=3) difference() {
      polygon(p);
      offset(delta=-width) polygon(p);
    }
    linear_extrude(height=34,scale=[0,1]) square([16,67],center=true);
  }
}