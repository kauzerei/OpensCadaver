include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fa=1/2;
$fs=1/2;
bsl=1/100;

phone_width=70;
phone_height=170;
edge_radius=5;
side_radius=10;

wall_width=4;
wall_height=4;
beam_width=8;
edge_size=22;
beam_pos=30;

charger_d=92;
charger_h=11;
camera_protrusion=3;

function phone()=rect([phone_width,phone_height],rounding=edge_radius);

function holder_crossection()=round_corners(round_corners(
                                [[0,charger_h],
                                [0,charger_h+wall_height],
                                [wall_width,charger_h+wall_height],
                                [wall_width,0],
                                [-wall_width,0],
                                [-wall_width,charger_h]],
                              cut=[0,1,1,1,0,0.5],
                              method="chamfer"
                              ),
                              cut=[1,0,0,0,0,0,0,0,0,0]);

module beam_structure() {
  translate([phone_width/2,phone_height/2]) circle(d=edge_size);
  translate([-phone_width/2,phone_height/2]) circle(d=edge_size);
  translate([phone_width/2,-phone_height/2]) circle(d=edge_size);
  translate([-phone_width/2,-phone_height/2]) circle(d=edge_size);
  hull() {
    translate([phone_width/2,phone_height/2]) circle(d=beam_width);
    translate([0,beam_pos]) circle(d=beam_width);
  }
  hull() {
    translate([-phone_width/2,phone_height/2]) circle(d=beam_width);
    translate([0,beam_pos]) circle(d=beam_width);
  }
  hull() {
    translate([phone_width/2,-phone_height/2]) circle(d=beam_width);
    translate([0,-beam_pos]) circle(d=beam_width);
  }
  hull() {
    translate([-phone_width/2,-phone_height/2]) circle(d=beam_width);
    translate([0,-beam_pos]) circle(d=beam_width);
  }
}

difference() {
  union() {
    intersection ()  {
      linear_extrude(height=30,convexity=2) beam_structure();
      union() {
        path_sweep2d(holder_crossection(),phone(),closed=true);
        linear_extrude(height=charger_h-camera_protrusion) polygon(phone());
      }
    }
    cylinder(d=charger_d+2*wall_width,h=charger_h);
  }
  translate([0,0,-bsl]) cylinder(d=charger_d,h=charger_h+2*bsl);
  rotate([90,0,0]) cylinder(d=14,h=2*phone_height);
}