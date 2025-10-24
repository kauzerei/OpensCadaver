include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;
//thickness=8;
base_width=100;
base_depth=70;
base_thickness=8;
base_rounding=4;
bath_width=120;
bath_depth=90;
bath_lip=4;
bath_rounding=8;
height=20;
eyelet_d=4;
eyelet_w=20;
eyelet_gap=0.5;
wall=3;

module servo_gear() {

}

module top_mechanics() {
  depth=bath_depth/2+bath_lip-base_depth/2-eyelet_gap;
  for (m=[[0,0,0],[0,1,0]]) mirror(m) difference() { //eyelets
    back(base_depth/2+eyelet_gap+depth/2) difference() {
      union() {
        ycyl(d=eyelet_d+2*wall,h=depth);
        up(eyelet_d/4+wall/2) cube([eyelet_d+2*wall,depth,eyelet_d/2+wall],center=true);
      }
      ycyl(d=eyelet_d,h=bath_depth-base_depth);
      
    }  
  }

}

module servo_mount() {

}

module top() {
  top_profile=bath_lip*[[0,0],[1,0],[1,-1],[-1,-1],[-1,1],[0,1]];
  path=rect([bath_width,bath_depth],rounding=bath_rounding);
  path_extrude2d(path,closed=true) polygon(top_profile);
}

module bottom() {
  linear_extrude(height=base_thickness) difference() { //base
    r=rect([base_width,base_depth],rounding=base_rounding);
    polygon(r);
    polygon(offset(r,r=-base_thickness));
  }
  for (m=[[0,0,0],[0,1,0]]) mirror(m) difference() { //eyelets
    hull() {
      translate ([0,base_depth/2-base_thickness/2,height]) ycyl(d=eyelet_d+2*wall,h=base_thickness);
      translate ([-eyelet_w/2,base_depth/2-base_thickness,base_thickness]) scale([1,1,0]) cube([eyelet_w,base_thickness,1]);
    }
    translate([0,base_depth/2-base_thickness/2,height]) ycyl(d=eyelet_d,h=base_thickness+2*bsl);
  }
}

down(height) bottom();
up(bath_lip+eyelet_d/2+wall) top();
top_mechanics();