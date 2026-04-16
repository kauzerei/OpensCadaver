include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;

part="rectangular_plank";//[gabelstapler_gabel,container_door,rectangular_plank]

if (part=="gabelstapler_gabel") {
  base_w=44;
  base_d=22;
  holes_dist=22.5;
  hole_d=4;
  head_d=9;
  fork_width1=15;
  fork_width2=10;
  fork_length=63;
  thickness_max=4;
  thickness_min=2;
  r=2;
  difference() {
    linear_extrude(thickness_max, convexity=4) difference() {
      offset(r=-r) offset(r=2*r) offset(r=-r) {
        polygon([[0,0],
                 [base_d+fork_length,0],
                 [base_d+fork_length,fork_width2],
                 [base_d,fork_width1],
                 [base_d,base_w-fork_width1],
                 [base_d+fork_length,base_w-fork_width2],
                 [base_d+fork_length,base_w],
                 [0,base_w]]);
       }
       translate([base_d/2,base_w/2-holes_dist/2]) circle(d=hole_d);
       translate([base_d/2,base_w/2+holes_dist/2]) circle(d=hole_d);
     }
     translate([base_d/2,base_w/2-holes_dist/2,thickness_min]) cylinder(d=head_d,h=thickness_max);
     translate([base_d/2,base_w/2+holes_dist/2,thickness_min]) cylinder(d=head_d,h=thickness_max);
     rotate([-90,0,0]) linear_extrude(base_w) {
       polygon([[0,-thickness_max],
                [base_d+fork_length,-thickness_max],
                [base_d+fork_length,-thickness_min]]);
     }
   }
}

if (part=="container_door") {
  height=74;
  width=32.5;
  thickness=5;
  protrusion_w=6.5;
  protrusion_length=5;
  rotate([90,0,0]) difference() {
    hull() {
      translate([width/2-thickness/2,0,0]) cylinder(d=thickness,h=height+2*protrusion_length);
      translate([-width/2+thickness/2,0,0]) cylinder(d=thickness,h=height+2*protrusion_length);
    }
    translate([0,0,protrusion_length/2]) cube([width-2*protrusion_w,thickness,protrusion_length],center=true);
    translate([0,0,height+1.5*protrusion_length]) cube([width-2*protrusion_w,thickness,protrusion_length],center=true);
  }
}

if (part=="rectangular_plank") {
  rect=[95,70];
  mount_rect=[77,48];
  screw_d=4;
  head_h=2;
  head_d=6;
  thickness=9;
  r=1;
  difference() {
    linear_extrude(height=thickness,convexity=5) {
      difference() {
        offset(r=r) offset(r=-r) square(rect,center=true);
        for (i=[-0.5,0.5]) for (j=[-0.5,0.5]) translate([mount_rect[0]*i,mount_rect[1]*j]) circle(d=screw_d);
        circle(d=6);
        translate([20,0]) circle(d=7);
      }
    }
    for (i=[-0.5,0.5]) for (j=[-0.5,0.5]) translate([mount_rect[0]*i,mount_rect[1]*j]) {
      translate([0,0,head_h]) cylinder(d1=head_d,d2=screw_d,h=(head_d-screw_d)/2);
      cylinder(d=head_d,h=head_h);
    }
  }
}