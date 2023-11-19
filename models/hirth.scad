id=16;
od=32;
n=30;
w=90;
bissl=0.01;
function hirth_height(d=32,n=30,w=90)=d*tan(asin(tan(90/n)/tan(w/2)));
module tooth(d=32,n=30,w=90) {
  x=d*cos(180/n)/2;
  y=d*sin(180/n)/2;
  h=d*tan(asin(tan(90/n)/tan(w/2)))/2;
  /*
  polyhedron(points=[[0,0,0],
                     [d,0,d*tan(b)],
                     [d*cos(180/n),d*sin(180/n),-d*tan(b)],
                     [d*cos(180/n),-d*sin(180/n),-d*tan(b)],
                     [0,0,-d*tan(b)]],
                     faces=[[0,2,1],[0,1,3],[1,2,3],[0,4,2],[0,3,4],[4,3,2]]);
  */
  polyhedron(points=[[0,0,h],
                     [d/2,0,2*h],
                     [x,y,0],
                     [x,-y,0],
                     [0,0,0]],
                     faces=[[0,2,1],[0,1,3],[1,2,3],[0,4,2],[0,3,4],[4,3,2]]);
  
}
module hirth(d=32,n=30,w=90) {
  for(i=[0:360/n:360-360/n])rotate([0,0,i])tooth();
}
h=hirth_height(d=od,n=n,w=w);
difference() {
  union() {
    translate([0,0,h])hirth(d=od,n=n,w=w);
    cylinder(h=h,d=od);
  }
  translate([0,0,bissl==undef?-0.01:-bissl])cylinder(h=2*h,d=id);
}