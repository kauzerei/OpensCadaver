d_crane=45;
wall=3;
h_mount=14;
bissl=1/100;
hdmi_x=12; //maximal thickness of adapter, some day OpenSCAD can get this data directly from hdmi_shape module
hdmi_y=27; //maximal width of adapter
d_bolt=4;
d_head=8;
cut=3;
/* [mount for rosette] */
mount_diameter=24;
mount_depth=10;
mount_wall=3;
bolt_circle_diameter=12;
bolt_diameter=2;
n_bolts=4;
$fa=1/1;
$fs=1/2;
module hdmi_holder(d_crane=45,wall=3,h_mount=14,bissl=1/100,hdmi_x=12,hdmi_y=27,d_bolt=4,d_head=8,cut=3,mount_diameter=24,mount_depth=10,mount_wall=3,bolt_circle_diameter=12,bolt_diameter=2,n_bolts=4) {
  difference() {
    hull() {
      cylinder(h=h_mount,d=d_crane+2*wall,center=true);
      minkowski() {
        translate([d_crane/2+2*wall+hdmi_x/2+d_bolt,0,0]) hdmi_shape(hdmi_x=hdmi_x,h_mount=h_mount);
        cylinder(d=2*wall,h=bissl,center=true);
      }
      rotate([0,-90,0])translate([0,0,d_crane/2]) intersection() {
        rosette_holder(depth=mount_depth,wall=mount_wall,diameter=mount_diameter,d_nut=d_head,d_bolt=d_bolt,bcd=bolt_circle_diameter,bd=bolt_diameter,nb=n_bolts,bissl=1/100,negative=false);
        cube([h_mount,mount_diameter,2*mount_depth],center=true);
      }
    }
    cylinder(h=2*h_mount,d=d_crane,center=true);
    translate([d_crane/2+2*wall+d_bolt+hdmi_x/2,0,0]) minkowski() {
      hdmi_shape(hdmi_x=hdmi_x,h_mount=h_mount);
      cylinder(d=bissl,h=2*bissl,center=true);
    }
    translate([d_crane/2+wall+d_bolt/2,0,0])rotate([90,0,0])cylinder(d=d_bolt,h=d_crane,center=true);
    translate([d_crane/2+wall+d_bolt/2,+d_crane/4,0])rotate([-90,0,0])cylinder(d=d_head,h=d_crane);
    translate([d_crane/2+wall+d_bolt/2,-d_crane/4,0])rotate([90,0,0])cylinder(d=d_head,h=d_crane);
    translate([0,-cut/2,-h_mount])cube([2*d_crane,cut,2*h_mount]);
    rotate([0,-90,0])translate([0,0,d_crane/2]) rosette_holder(depth=mount_depth,wall=mount_wall,diameter=mount_diameter,d_nut=d_head,d_bolt=d_bolt,bcd=bolt_circle_diameter,bd=bolt_diameter,nb=n_bolts,bissl=1/100,negative=true);

  }
}
module hdmi_shape(hdmi_x,h_mount) {
  cube([hdmi_x,20,h_mount],center=true);
  cube([7,27,5],center=true);
}
module rosette_holder(depth=10,wall=3,diameter=20,d_nut=8,d_bolt=4,bcd=12,bd=2,nb=4,bissl=1/100,negative=false) {
  difference() {
    if (!negative) cylinder(h=depth,d=diameter);
      union() {
        translate([0,0,-bissl]) cylinder(h=depth+2*bissl, d=d_bolt);
        for (i=[180/nb:360/nb:360]) rotate([0,0,i])translate([bcd/2,0,-bissl]) cylinder(h=depth+2*bissl,d=bd);
        translate([0,0,-depth]) cylinder(d=d_nut,h=2*depth-wall,$fn=6);
      }
  }
}
hdmi_holder(d_crane=45,wall=3,h_mount=14,bissl=1/100,hdmi_x=12,hdmi_y=27,d_bolt=4,d_head=8,cut=3,mount_diameter=24,mount_depth=10,mount_wall=3,bolt_circle_diameter=12,bolt_diameter=2,n_bolts=4);
//hdmi_shape();
//rosette_holder();