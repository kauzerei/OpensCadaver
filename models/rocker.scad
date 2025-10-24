include <../import/BOSL2/std.scad>
include <../import/BOSL2/gears.scad>

$fa=1/2;
$fs=1/2;
bsl=1/100;
base_width=140;
base_depth=90;
base_thickness=6;
base_rounding=4;
bath_width=160;
bath_depth=115;
bath_lip=3;
bath_rounding=15;
height=30;
eyelet_d=4;
eyelet_w=16;
eyelet_gap=0.5;
wall=3;
servo_gear=6;
gear_ratio=9;
gear_pitch=3;
gear_thickness=6;
servo_d=5;
servo_ax=4;
screw_d=3;
screw_offset=eyelet_d/2+2*wall+screw_d/2;

module servo_gear() {
  difference() {
    union() {
      spur_gear(gear_pitch,servo_gear,gear_thickness);
      up(gear_thickness/2) cylinder(d=servo_d+2*wall,h=servo_ax);
    }
    up(gear_thickness/2) cylinder(d=servo_d,h=servo_ax+bsl);
  }
}

module top_mechanics() {
  depth=bath_depth/2+bath_lip-base_depth/2-eyelet_gap;
  cyld=2*root_radius(mod=gear_pitch/PI,teeth=servo_gear*gear_ratio)-2*gear_thickness;
  for (m=[[0,0,0],[0,1,0]]) mirror(m) difference() { //eyelets
    back(base_depth/2+eyelet_gap+depth/2) difference() {
      union() {
        ycyl(d=eyelet_d+2*wall,h=depth);
        up(eyelet_d/4+wall/2) cube([eyelet_d+2*wall,depth,eyelet_d/2+wall],center=true);
        back(-base_depth/2-eyelet_gap-depth/2+bath_depth/2) {
          right(cyld/4)up(eyelet_d/4+wall/2) cube([cyld/2,bath_lip*2,eyelet_d/2+wall],center=true);
        }
      }
      ycyl(d=eyelet_d,h=bath_depth-base_depth);
      back(-base_depth/2-eyelet_gap-depth/2+bath_depth/2) right(screw_offset) down(bsl){
        cylinder(d=screw_d,h=eyelet_d/2+wall);
      }
    }  
  }
  right(cyld/2+gear_thickness/2)up(wall/2+eyelet_d/4)cube([gear_thickness,bath_depth+2*bath_lip,wall+eyelet_d/2],center=true);
  fwd(gear_thickness/2)
  left(bath_width/2+bath_lip)
  difference() {
  cube([cyld/2+gear_thickness/2+bath_width/2,gear_thickness,wall+eyelet_d/2]);
  back(gear_thickness/2)right(bath_lip) down(bsl)cylinder(d=screw_d,h=wall+eyelet_d/2+2*bsl);
  }
  yrot(90) xrot(90) spur_gear(gear_pitch,servo_gear*gear_ratio,gear_thickness,0,hide=servo_gear*(gear_ratio-1));
}

module servo_mount() {

}

module top() {
  top_profile=bath_lip*[[0,0],[1,0],[1,-1],[-1,-1],[-1,1],[0,1]];
  path=rect([bath_width,bath_depth],rounding=bath_rounding);
  difference() {
    path_extrude2d(path,closed=true) polygon(top_profile);
    for (m=[[0,0,0],[0,1,0]]) mirror(m) {
      right(screw_offset) back(bath_depth/2) down(bath_lip+bsl) cylinder(d=screw_d,h=bath_lip);
    }
    left(bath_width/2)down(bath_lip+bsl)cylinder(d=screw_d,h=bath_lip);
  }
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

//yrot(180/gear_ratio)
down(height) bottom();
up(bath_lip+eyelet_d/2+wall) top();
top_mechanics();
xrot(90)servo_gear();