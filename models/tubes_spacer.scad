d1=26;
d2=30;
distance=90;
allowed_bend=5;
wall=3;
height=20;
center_to_center=distance+d1/2+d2/2;
angle=30;
$fa=1/1;
$fs=1/2;
bissl=1/100;
module one_side(d,wall,bend) {
  angle=asin((d/2-bend/2+wall/2)/(d/2+wall/2));
  difference() {
    circle(d=d+2*wall);
    circle(d=d);
    p=(d/2+wall)/cos(angle)+bissl;
    polygon([[0,0],[p*cos(angle),p*sin(angle)],[p*cos(angle),-p*sin(angle)]]);
    translate([(d/2+wall/2)*cos(angle),(d/2+wall/2)*sin(angle)])circle(d=wall);
    translate([(d/2+wall/2)*cos(angle),-(d/2+wall/2)*sin(angle)])circle(d=wall);
  }
  translate([(d/2+wall/2)*cos(angle),(d/2+wall/2)*sin(angle)])circle(d=wall);
  translate([(d/2+wall/2)*cos(angle),-(d/2+wall/2)*sin(angle)])circle(d=wall);
}
module spacer() {
  linear_extrude(height=height,convexity=4) {
    translate([center_to_center/2,0,0]) one_side(d=d1,wall=wall,bend=allowed_bend);
    mirror([1,0,0])translate([center_to_center/2,0,0]) one_side(d=d2,wall=wall,bend=allowed_bend);
    hull() {
      translate([center_to_center/2,0])rotate(angle)translate([-d1/2-wall/2,0])circle(d=wall);
      translate([-center_to_center/2,0])rotate(-angle)translate([d2/2+wall/2,0])circle(d=wall);
    }
        hull() {
      translate([center_to_center/2,0])rotate(-angle)translate([-d1/2-wall/2,0])circle(d=wall);
      translate([-center_to_center/2,0])rotate(angle)translate([d2/2+wall/2,0])circle(d=wall);
    }
  }
}
//one_side(d=d1,wall=wall,bend=allowed_bend);
spacer();