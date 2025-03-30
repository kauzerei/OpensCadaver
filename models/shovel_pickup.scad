$fa=1/2;
$fs=1/2;
shovel_d=35;
screws_dist=30;
mount_hole=3;
extra=5;
center_hole=6;
total_height=21;
od=18;
wall=1.6;
air=1;
bissl=1/100;

module surface_mount() {
  intersection() {
    rotate([0,90,0])difference() {
      cylinder(d=shovel_d+2*wall,h=screws_dist+2*extra,center=true);
      cylinder(d=shovel_d,h=screws_dist+2*extra+bissl,center=true);
      translate([(shovel_d+2*wall)/2,0,0]) cube([shovel_d+2*wall,shovel_d+2*wall,screws_dist+2*extra+bissl],center=true);
      rotate([0,-90,0])translate([screws_dist/2,0,0])cylinder(d=mount_hole,h=shovel_d);
      rotate([0,-90,0])translate([-screws_dist/2,0,0])cylinder(d=mount_hole,h=shovel_d);
    }
    hull() {
      cylinder(d=od+2*wall+2*air,h=shovel_d);
      translate([screws_dist/2,0,0])cylinder(d=2*extra,h=shovel_d);
      translate([-screws_dist/2,0,0])cylinder(d=2*extra,h=shovel_d);
    }
  }
}
surface_mount();