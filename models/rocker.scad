include <../import/BOSL2/std.scad>
include <../import/BOSL2/gears.scad>
part="NOSTL_all";//[NOSTL_all,top,top_mech,bottom,servo_gear,enclosure]
$fa=1/2;
$fs=1/2;
bsl=1/100;
base_width=140;
base_depth=88;
base_thickness=4;
base_rounding=0;
bath_width=161;
bath_depth=106;
bath_lip=4;
bath_rounding=0;//15;
bath_chamfer=15;
height=20;
eyelet_d=4;
eyelet_w=16;
eyelet_gap=0.5;
gear_gap=0.0;
enclosure_gap=0.5;
enclosure_wall=1.2;
wall=2;
servo_gear=6;
gear_ratio=10;
gear_pitch=4;
gear_thickness=10;
mech_thickness=4;
servo_d=5;
servo_ax=4;
screw_d=3;
enclosure_h=25;
holes=[[41,17],[71,17],[11,17]];
hole_d=7;

screw_offset=eyelet_d/2+2*wall+screw_d/2;
dist=gear_dist(circ_pitch=gear_pitch,teeth1=servo_gear,teeth2=servo_gear*gear_ratio)+gear_gap;
max_rotation=90/gear_ratio;
global_rotation=0*max_rotation;
servo_position=[dist*cos(90/gear_ratio),-gear_thickness/2,-dist*sin(90/gear_ratio)];
thickness=eyelet_d+2*wall;
cylr=root_radius(mod=gear_pitch/PI,teeth=servo_gear*gear_ratio);

module servo_gear() {
  difference() {
    union() {
      spur_gear(gear_pitch,servo_gear,gear_thickness);
      up(gear_thickness/2) cylinder(d=servo_d+2*wall,h=servo_ax);
    }
    up(gear_thickness/2) cylinder(d=servo_d,h=servo_ax+bsl);
    down(gear_thickness/2+bsl) cylinder(d=2.5,h=gear_thickness+2*bsl);
  }
}

module top_mechanics() {
  depth=bath_depth/2+bath_lip-base_depth/2-eyelet_gap;
  cyld=2*root_radius(mod=gear_pitch/PI,teeth=servo_gear*gear_ratio)-2*mech_thickness;
  yflip_copy() difference() { //eyelets
    back(base_depth/2-base_thickness-eyelet_gap-mech_thickness/2)
    //back(base_thickness/2)
    difference() {
      union() {
        ycyl(d=eyelet_d+2*wall,h=mech_thickness);
        up(eyelet_d/4+wall/2) cube([eyelet_d+2*wall,mech_thickness,eyelet_d/2+wall],center=true);
      }
      ycyl(d=eyelet_d,h=mech_thickness+bsl);
      back(-base_depth/2-eyelet_gap-depth/2+bath_depth/2) right(screw_offset) down(bsl){
        cylinder(d=screw_d,h=eyelet_d/2+wall);
      }
    }  
  }
  down(mech_thickness-wall-eyelet_d/2)difference() {
    union() { //bars
      //left(bath_width/2+bath_lip)cube([bath_width/2+bath_lip+cylr,thickness,mech_thickness],anchor=LEFT+BOTTOM);
      cube([2*cylr,thickness,mech_thickness],anchor=CENTER+BOTTOM);
//      cube([thickness,2*cylr,mech_thickness],anchor=CENTER+BOTTOM);
      cube([thickness,base_depth-2*base_thickness-2*eyelet_gap-2*mech_thickness,mech_thickness],anchor=CENTER+BOTTOM);
    }
    for (tr=(cylr-screw_d/2-wall)*[[1,0,0],[0,1,0],[-1,0,0],[0,-1,0]]) translate(tr) { //screw holes
      down(bsl)cylinder(d=screw_d,h=mech_thickness+2*bsl);
    }
  }
  yrot(90) xrot(90) spur_gear(gear_pitch,servo_gear*gear_ratio,thickness,0,hide=floor(servo_gear*(gear_ratio-0.5))-1);
}

module servo_mount() {
  fwd(servo_ax) right(5.45) difference() {
    up(12.5/2)cube([34,8,100],anchor=TOP+BACK);
    back(bsl)cube([23.5,8+2*bsl,12.5+bsl],anchor=CENTER+BACK);
    back(bsl)right(14)ycyl(d=3,h=8+2*bsl,anchor=BACK);
    back(bsl)left(14)ycyl(d=3,h=8+2*bsl,anchor=BACK);
  }
}

module top() {
  top_profile=bath_lip*[[0,0],[1,0],[1,-1],[-1,-1],[-1,1],[0,1]];
  path=rect([bath_width,bath_depth],chamfer=bath_chamfer,rounding=bath_rounding);
  path_extrude2d(path,closed=true) polygon(top_profile);
  difference() {
    union() {
      cube([bath_width,thickness,bath_lip],anchor=TOP);
      cube([thickness,bath_depth,bath_lip],anchor=TOP);
    }
    for (tr=(cylr-screw_d/2-wall)*[[1,0,0],[0,1,0],[-1,0,0],[0,-1,0]]) translate(tr) { //screw holes
      up(bsl)cylinder(d=screw_d,h=bath_lip+2*bsl,anchor=TOP);
    }
  }  
}    
//    for (m=[[0,0,0],[0,1,0]]) mirror(m) {
//      right(screw_offset) back(bath_depth/2) down(bath_lip+bsl) cylinder(d=screw_d,h=bath_lip);
//    }
//    left(bath_width/2)down(bath_lip+bsl)cylinder(d=screw_d,h=bath_lip);

module bottom() {
  linear_extrude(height=base_thickness) difference() { //base
    r=rect([base_width,base_depth],rounding=base_rounding);
    polygon(r);
    polygon(offset(r,r=-base_thickness));
  }
  yflip_copy() difference() { //eyelets
    hull() {
      translate ([0,base_depth/2-base_thickness/2,height]) ycyl(d=eyelet_d+2*wall,h=base_thickness);
      translate ([-eyelet_w/2,base_depth/2-base_thickness,base_thickness]) scale([1,1,0]) cube([eyelet_w,base_thickness,1]);
    }
    translate([0,base_depth/2-base_thickness/2,height]) ycyl(d=eyelet_d,h=base_thickness+2*bsl);
  }
  fwd(gear_thickness/2+servo_ax)cube([base_width,8,base_thickness],anchor=BACK+BOTTOM);
  intersection() {
    cube([base_width,base_depth,100],anchor=BOTTOM);
    up(height) translate(servo_position) yrot(max_rotation) servo_mount();
  }
}
module enclosure(){
  r=rect([base_width,base_depth],rounding=base_rounding);
  difference() {
    union() {
      linear_extrude(height=enclosure_h+2*base_thickness,convexity=4) difference() { //walls
        polygon(offset(r,r=enclosure_gap+enclosure_wall));
        polygon(offset(r,r=enclosure_gap));
      }
      up(enclosure_h+0.5*base_thickness) difference() { 
        linear_extrude(height=base_thickness,center=true) polygon(offset(r,r=enclosure_gap));
        linear_extrude(height=base_thickness+bsl,center=true,scale=[(base_width-2*base_thickness)/(base_width+2*enclosure_gap),(base_depth-2*base_thickness)/(base_depth+2*enclosure_gap)]) polygon(offset(r,r=enclosure_gap));
    }
  }
    fwd(base_depth/2+enclosure_gap+enclosure_wall/2) right(base_width/2) for (hole=holes) {
      left(hole[0]) up(hole[1]) {
        ycyl(d=hole_d,h=enclosure_wall+bsl);
        back(enclosure_wall/2)ycyl(d=16,h=base_thickness+enclosure_gap,anchor=FRONT);
        }
    }
  }
  down(enclosure_wall)linear_extrude(height=enclosure_wall) { //floor
    polygon(offset(r,r=enclosure_gap+enclosure_wall));
  }
}
//render() 
{
if (part=="NOSTL_all") 
//render() 
  {
  down(height) bottom();
  yrot(global_rotation) {
    up(bath_lip+eyelet_d/2+wall+1) top();
    top_mechanics();
  }
  yrot(90/gear_ratio)right(dist)yrot(-global_rotation*gear_ratio)yrot(180/servo_gear)xrot(90)servo_gear();
  //yrot(90/gear_ratio)right(dist)yrot(180/servo_gear)xrot(90)servo_gear();
  down(height+enclosure_h+base_thickness) enclosure();
}
if (part=="top") top();
if (part=="top_mech") mirror([0,0,1])top_mechanics();
if (part=="bottom") bottom();
if (part=="servo_gear") servo_gear();
if (part=="enclosure") enclosure();
}