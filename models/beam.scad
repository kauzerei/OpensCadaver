$fa=1/1;
$fs=1/2;
wall=2;
hole=4;
hd=20;
height=30;
vd=height-wall;
segments=1;
radius=1;
thickness=5;
offset=wall/2+hole/2;
linear_extrude(thickness) difference() {
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
