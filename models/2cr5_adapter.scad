cell_diameter=17;
cell_height=35.5;
bat_height=44;
flat=15;
slack=0.8;
contact_width=5.5;
contact_bump=0.5;
contact_channel=0.6;
$fa=1/2;
$fs=1/2;
bsl=1/100;
thickness=(bat_height-cell_height)/2; //thick ess of thick parts at top and bottom of the battery

module plussign(l=7,w=2) {
  mirror([0,0,1]) roof(method="straight") {
    square([l,w],center=true);
    square([w,l],center=true);
  }
}

rotate([90,0,0]) { //best printing position
  difference() {
    linear_extrude(height=bat_height,center=true,convexity=3) {
      translate([-cell_diameter/2,0]) circle(d=cell_diameter);
      translate([cell_diameter/2,0]) circle(d=cell_diameter);
      translate([-cell_diameter/2,-cell_diameter/2]) square([cell_diameter,flat]);
    }
    for (tr=[[-cell_diameter/2,0,0],[cell_diameter/2,0,0]]) translate(tr) {
      cylinder(d=cell_diameter+slack,h=cell_height,center=true); //battery cutouts
      translate([-contact_width/2,0,0]) { //top contact channels
        translate([0,0,cell_height/2-bsl]) { //inner and side parts
          translate([0,-contact_width/2-contact_channel,0]) cube([contact_width,contact_channel,thickness*0.7]);
          translate([0,contact_width/2,0]) cube([contact_width,cell_diameter/2-contact_width/2,contact_channel]);
          translate([0,cell_diameter/2-contact_channel*2,0]) cube([contact_width,2*contact_channel,thickness+2*bsl]);
        }
        translate([0,cell_diameter/2-contact_width-contact_channel,bat_height/2]) { //outer part
          translate([0,0,-contact_channel]) cube([contact_width,contact_width,contact_channel+bsl]);
          translate([0,0,-thickness*0.7]) cube([contact_width,contact_channel,thickness*0.7]);
        }
      }
    }
    translate([-cell_diameter/2,-contact_width/2,bat_height/2+bsl]) plussign();
    for (m=[[0,0,0],[1,0,0]]) mirror(m) { //bottom contact channels
      translate([cell_diameter/2+contact_width/2,-contact_width/2,-bat_height/2+thickness/2]) {
        cube([contact_channel,contact_width,thickness/2+bsl]);
      }
    }
  }
  for (m1=[[0,0,0],[0,0,1]]) for (m2=[[0,0,0],[1,0,0]]) mirror(m1) mirror(m2) { //four bumps
    translate([cell_diameter/2,0,-cell_height/2]) linear_extrude(height=contact_bump, scale=0.3) {
      square(contact_width,center=true);
    }
  }
}


