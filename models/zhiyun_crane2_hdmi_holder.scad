d_crane=45;
wall=3;
h_mount=14;
bissl=1/100;
hdmi_x=12; //maximal thickness of adapter, some day OpenSCAD can get this data directly from hdmi_shape module
hdmi_y=27; //maximal width of adapter
d_bolt=4;
d_head=8;
cut=3;
$fa=1/1;
$fs=1/2;
module hdmi_holder() {
  difference() {
    hull() {
      cylinder(h=h_mount,d=d_crane+2*wall,center=true);
      minkowski() {
        translate([d_crane/2+2*wall+hdmi_x/2+d_bolt,0,0])hdmi_shape();
        cylinder(d=2*wall,h=bissl,center=true);
      }  
    }
    cylinder(h=2*h_mount,d=d_crane,center=true);
    translate([d_crane/2+2*wall+d_bolt+hdmi_x/2,0,0]) minkowski() {
      hdmi_shape();
      cylinder(d=bissl,h=2*bissl,center=true);
    }
    translate([d_crane/2+wall+d_bolt/2,0,0])rotate([90,0,0])cylinder(d=d_bolt,h=d_crane,center=true);
    translate([d_crane/2+wall+d_bolt/2,+d_crane/4,0])rotate([-90,0,0])cylinder(d=d_head,h=d_crane);
    translate([d_crane/2+wall+d_bolt/2,-d_crane/4,0])rotate([90,0,0])cylinder(d=d_head,h=d_crane);
    translate([0,-cut/2,-h_mount])cube([2*d_crane,cut,2*h_mount]);
  }
}
module hdmi_shape() {
  cube([hdmi_x,20,h_mount],center=true);
  cube([7,27,5],center=true);
}
hdmi_holder();
//hdmi_shape();