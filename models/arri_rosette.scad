thickness=1.5;
screw_head_space=1;
screw_side_space_diameter=16;
bcd=10;
n_screws=4;
d_center=4;
d_circle=2.5;
$fa=1/1;
$fs=1/2;

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
  for(i=[0:360/n:360-360/n])rotate([0,0,i])tooth(d=d,n=n,w=w);
}
module hirth_limited(od=32,id=16,h=1.4,n=30,w=90) {
  intersection() {
    hirth(d=od/cos(180/n),n=n,w=w);
    if (h!=0) difference() {
      cylinder(h=h!=0?h:hirth_height(od/cos(180/n),n,w),d=od,$fn=n);
      translate([0,0,-0.01])cylinder(h=h+0.02,d=id,$fn=n);
    }
  }
}
//hirth();
//hirth_limited(od=od,id=id,h=h,n=n,w=w);
module arri_rosette(thickness=1.5,screw_head_space=1,screw_side_space_diameter=16,bcd=12,n_screws=4,d_center=4,d_circle=2.5) {
  difference() {
    union() {
      translate([0,0,thickness+screw_head_space]) intersection() {
        hirth(d=33,n=60,w=90);
        cylinder(d1=32,d2=32-2*hirth_height(32/cos(180/60),60,90),h=hirth_height(32/cos(180/60),60,90),$fn=60);
        }
      cylinder(h=thickness+screw_head_space,d=32,$fn=60);  
    }
    translate([0,0,thickness]) cylinder(d=screw_side_space_diameter,h=screw_head_space+hirth_height(32/cos(180/60),60,90));
    for (i=[0:360/n_screws:360-360/n_screws]) rotate([0,0,i])translate([bcd/2,0,-0.01]) cylinder(h=thickness+0.02,d=d_circle);
    translate([0,0,-0.01]) cylinder(h=thickness+0.02,d=d_center);
  }  
}
arri_rosette(thickness=thickness, screw_head_space=screw_head_space, screw_side_space_diameter=screw_side_space_diameter, bcd=bcd, n_screws=n_screws, d_center=d_center, d_circle=d_circle);