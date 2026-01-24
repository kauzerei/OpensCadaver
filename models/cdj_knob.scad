/* Thingiverse/Printables description:
Pioneer CDJ800 Vinyl Touch/Release Knob

Replica of DAA1194 part.
According to the internet, it should be compatible with
CDJ-1000, CDJ-2000, CDJ-800, CDJ-850, CDJ-900, CDJ-TOUR1, XDJ-1000, and XDJ-1000MK2.

I didn't find any good D-shaft knob, so I designed my own.
There are a million knob collections and libraries on Printables/Thingiverse, but none have the correct geometry.

Print as is without supports, clean up a little to get rid of print lines and paint a white line with nail polish.

My github repo for all of my models may contain a newer version of this model, if I decide to update something and forget to reupload: https://github.com/kauzerei/OpensCadaver/blob/main/models/cdj_knob.scad
*/

$fs=1/4;
$fa=1/4;
shaft_h=12; //total length of the shaft
shaft_offset=6; //how much shaft protrudes below the surface
shaft_d=6; //diameter of round part of the shaft
shaft_cut=1.5; //the "filed" away part of the D-shaft
wall=1.2; //wall thickness
gap=1; //cut width of shaft holding part
tol=0.0; //positive if knob is too small for the shaft, negative if too large
depth=0.6; //depth of surface features ("knurls")
ld=14; //knob lower diameter
ud=13; //knob upper diameter
height=15; //knob height
n_feats=16; //number of knurls, including the "missing" one, where the groove for the paint is
groove_width=1.6; //pointer groove

module shaft() { //shape of the shaft itself
  difference() {
    circle(d=shaft_d);
    translate([-shaft_d/2,-shaft_d/2]) square([shaft_d,shaft_cut]);
  }
}

mirror([0,0,1]) { //to print in optimal orientation
  translate([0,0,-shaft_offset])linear_extrude(height=shaft_h) { //shaft holding part
    mirror([0,1]) difference() {
      offset(r=tol+wall) shaft();
      offset(r=tol) shaft();
      translate([-gap/2,-shaft_d/2-tol-wall])square([gap,shaft_d/2+tol+wall]);
    }
  }

  difference() {
    union() { //knob part
      translate([0,0,0])cylinder(d1=ld-2*depth,d2=ud-2*depth,h=15);
      translate([0,0,0])cylinder(d=ld,h=2*depth); //skirt
      for (angle=[360/n_feats:360/n_feats:360-1]) rotate([0,0,angle]) { //grippy features on the side
        hull() {
          translate([0,ud/2-depth,height-depth]) sphere(r=depth);
          translate([0,ld/2-depth,depth]) cylinder(r=depth,h=1/100); 
        }
      }
    }
    hull() { //pointer groove upper
      translate([0,ud/2-depth,height]) sphere(d=groove_width);
      translate([0,0,height]) sphere(d=groove_width);
    }
    hull() { //pointer groove on side
      translate([0,ud/2-depth,height]) sphere(d=groove_width);
      translate([0,ld/2-depth,2*depth+groove_width/2]) sphere(d=groove_width);
    }
    translate([0,0,-1/100])cylinder(d=ud-2*depth-2*wall,h=shaft_h-shaft_offset); //place for shaft holder
  }
}