/*
Thingiverse/printables description

Fret slotting mitre (miter) box for adding extra microtonal frets.

A truly minimal fret slotting mitre (miter) box. It's designed for making additional slots in already fretted instruments: ideal if you're too much into Angine de Poitrine, KGLW, Massive Audio Nerve and other microtonal stuff and want to modify your guitar. Should be also fine for just slotting a fingerboard billet, why not.

It is usable without any guiding bearings, better if you can add 4 of them above the teeth to further limit the unwanted motions of the blade inside the tool, or put 8 bearings with a plate on top to pretty much guarantee the blade is always in one plane.
The model is parametric and written in OpenSCAD, you can customize it for the geometry of the saw and bearings you want to use. The default values and generated stl files are for 62mm wide fine saw and 625 bearings (5x16x5mm). Holding the tool together are 4 threaded rods M3x85 and 8 M3 nuts.

Mark where you want to cut, align the mitre box and press it against the fretboard so it doesn't move while cutting. A couple of shims (with the same radius as the fretboard) go between the flat surface of the tool and the neck. Those shims have cutouts for existing frets and they make sure, that the saw is always perpendicular to the surface.

I made the tool size minimal, so that it doesn't collide with the tuners, headstock or the body (you have to remove the nut though), but you may change any dimensions, they are commented nicely in OpenSCAD script.
What this model does not do is limiting the cut depth. If your saw has a depth stop, it's trivial to modify the model: make a wider cut in the box and put the bearings higher. Mine doesn't, so I didn't design for that.

This tool is part of a bigger project: I'm making a replica of Angine de Poitrine doubleneck instrument. Check this and related posts if you are interested https://social.tchncs.de/@kauzerei/116550865787433029
*/

bsl=1/100;
$fs=1/1;
$fa=1/1;

part="NOSTL_all";//[miter,stab,spacers,shim,NOSTL_all]

/* [miter box parameters] */
length=70;
width=65;
height=12;
depth=8; //max cut depth above shim
cut=0.75; //cut width
wall=4; //thickness of horizontal and vertical walls
rest=15; //width of feature that rests against fretboard/frets

//experimental feature, ended up not using
elongated=false;
add_length=35;

/* [bearing parameters] */
od=16; //outer diameter
id=5; //inner diameter
bh=5; //height
step=2; //step that holds bearing on axis, also dfedines stab beams width

/* [saw geometry] */
clearance_bot=10; //ball bearing from saw teeth
clearance_top=15; //ball bearing from saw ridge
saw_blade=62;

/* [screw and nut parameters] */
screw=3.5;
insert_h=3;
insert_w=6.5;
insert_hex=true; //false for threaded inserts instead of hex nuts

/* [shim ] */
fret_height=2;
fret_width=3;
fret_radius=300; //12 inch radius
slack=0.1;

bearing_p1=height+clearance_bot;
bearing_p2=height-depth+saw_blade-clearance_top-bh;
ox=width/2+od/2;
oy=od/2+cut/2;
tr=[[ox,oy],[ox,-oy],[-ox,-oy],[-ox,oy],[ox,oy]];
spacers_h=[bearing_p1-height-wall,
           bearing_p2-bearing_p1-bh,
           height+wall+saw_blade-bearing_p2-bh];
spacers_b=[true,true,false];

module half(add=false) {
  difference() {
    hull() {
      translate([width/2,-length/2]) cube([wall,length,height+wall]);
      translate([ox,oy,0])cylinder(d=od,h=height+wall);
      translate([ox,-oy,0])cylinder(d=od,h=height+wall);
    }
    translate([0,0,height-depth]) cube([width+2*od,cut,depth+wall+bsl]);
    translate([ox,oy,-bsl])cylinder(d=screw,h=height+wall+2*bsl);
    translate([ox,-oy,-bsl])cylinder(d=screw,h=height+wall+2*bsl);
    translate([ox,oy,-bsl])cylinder(d=insert_w,h=insert_h+2*bsl,$fn=insert_hex?6:16);
    translate([ox,-oy,-bsl])cylinder(d=insert_w,h=insert_h+2*bsl,$fn=insert_hex?6:16);
  }
  if(add) translate([width/2,length/2]) cube([wall,add_length,height+wall]);
}

module stab() {
  for (i=[0:1:3]) difference() {
    hull() {
      translate(tr[i]) cylinder(d=id+2*step,h=wall);
      translate(tr[i+1]) cylinder(d=id+2*step,h=wall);
    }
    translate([0,0,-bsl]) translate(tr[i]) cylinder(h=wall+2*bsl,d=screw);
    translate([0,0,-bsl]) translate(tr[i+1]) cylinder(h=wall+2*bsl,d=screw);
  }
}

module spacer(h,bearing=true) {
  difference() {
    union() {
      if(bearing) cylinder(h=h+bh,d=id);
      cylinder(h=h,d=id+2*step);
    }
    translate([0,0,-bsl]) cylinder(d=screw,h=h+bh+2*bsl);
  }
}

module miter_box(add=false) {
  for (m=[[0,0,0],[1,0,0]]) mirror(m) half(add);
  translate([-width/2,length/2-rest,height]) cube([width,rest,wall]);
  translate([-width/2,-length/2,height]) cube([width,rest,wall]);
  if (add) translate([-width/2,length/2+add_length-rest,height]) cube([width,rest,wall]);
}

module shim() {
  difference() {
    translate([-width/2+slack,-rest/2,0]) cube([width-2*slack,rest,10]);
    translate([0,0,fret_radius+fret_height])rotate([90,0,0]) cylinder(h=rest+bsl,r=fret_radius,center=true);
    translate([0,0,fret_radius+fret_height])rotate([90,0,0]) cylinder(h=fret_width,r=fret_radius+fret_height,center=true);
  }
}

if (part=="NOSTL_all") {
  color([0.5,0.6,0.6]) miter_box(elongated);
  color([0.6,0.5,0.6]) translate([0,0,height+wall+saw_blade]) stab();
  color([0.6,0.7,0.5]) translate([0,-length/2+rest/2,height]) mirror([0,0,1]) shim();
  color([0.6,0.7,0.5]) translate([0,length/2-rest/2,height]) mirror([0,0,1]) shim();
  for (pos=tr) translate([pos[0],pos[1],bearing_p1]) cylinder(d=od,h=bh);
  for (pos=tr) translate([pos[0],pos[1],bearing_p2]) cylinder(d=od,h=bh);
  color([0.6,0.6,0.5]) for (pos=tr) translate([pos[0],pos[1],height+wall]) spacer(bearing_p1-height-wall);
  color([0.5,0.5,0.6]) for (pos=tr) translate([pos[0],pos[1],bearing_p1+bh]) spacer(bearing_p2-bearing_p1-bh);
  color([0.5,0.6,0.5]) for (pos=tr) translate([pos[0],pos[1],bearing_p2+bh]) spacer(height+wall+saw_blade-bearing_p2-bh,false);
}
if (part=="miter") mirror([0,0,1]) miter_box(elongated);
if (part=="stab") stab();
if (part=="spacers") for (i=[0:1:2]) for (j=[0:1:3]) translate(od*[i,j]) spacer(spacers_h[i],spacers_b[i]);
if (part=="shim") shim();