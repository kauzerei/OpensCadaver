$fa=1/1;
$fs=1/2;
bissl=1/100;
wall=1.6;
hole=3;
hd=10;
height=40;
vd=height-wall;
segments=14;
radius=1;
thickness=7;
offset=wall/2+hole/2;
difference() {
  linear_extrude(thickness, convexity=4) difference() {
  offset(r=-radius)offset(r=radius)union() {
    for (i=[0:hd:hd*(segments-1)]) translate ([i,0]) {
      for (tr=[[[hd,0],[0,0]],[[-hd/2,vd],[0,0]],[[hd/2,vd],[0,0]],[[hd/2,vd],[-hd/2,vd]]]) hull() { //diagonals
        translate(tr[0])circle(d=wall);
        translate(tr[1]) circle(d=wall);
      }
      for (tr=[[hd/2,vd-offset],[-hd/2,vd-offset],[hd,offset],[0,offset]]) translate(tr)circle(d=2*wall+hole); //big circles
    }
    for (tr=[[[-hd/2-offset,0],[0,0]],[[-hd/2-offset,0],[-hd/2-offset,vd]],[[-hd/2-offset,vd],[-hd/2,vd]]]) hull() {//left
      translate(tr[0])circle(d=wall);
      translate(tr[1]) circle(d=wall);
    }
hull() for (tr=[[0,0],[-hd/2-offset,0],[-hd/2-offset,vd],[-hd/2,vd]]) translate(tr) circle(d=wall); //solid triangle
    for (tr=[[[hd*segments+offset,0],[0,0]],[[hd*segments+offset,0],[hd*segments+offset,vd]],[[hd*segments+offset,vd],[hd*(segments-0.5),vd]],[[hd*segments,0],[hd*(segments-0.5),vd]]]) hull() { //right
      translate(tr[0])circle(d=wall);
      translate(tr[1]) circle(d=wall);
    }
  }
  for (i=[0:segments]) {
    translate([i*hd,offset]) circle(d=hole);
    translate([(i-0.5)*hd,vd-offset]) circle(d=hole);
  }
  }
#translate([-hd/2-offset-wall/2,height/4-wall,thickness/2])rotate([0,90,0])cylinder(d=hole,h=hd-wall);
#translate([-hd/2-offset-wall/2,height/2-wall/2,thickness/2])rotate([0,90,0])cylinder(d=hole,h=hd-wall);
#translate([-hd/2-offset-wall/2,height*3/4,thickness/2])rotate([0,90,0])cylinder(d=hole,h=hd-wall);
}
