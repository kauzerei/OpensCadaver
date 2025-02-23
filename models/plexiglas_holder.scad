//Plexiglas holder for enclosing 3d-printer in the shelf
//Project: Kauzerei Werkstatt

bissl=1/100;
$fa=1/1;
$fs=1/2;
thickness=3;
wall=3;
screw=4;
width=16;
upper_length=20;
lower_length=7;
guide_length=32;
part="upper-left";//[upper-left,upper-right,lower-left,lower-right,guide]

module bohrung(screw,wall) {
translate([0,0,-bissl]) cylinder(d=screw,h=wall+2*bissl);
translate([0,0,-bissl]) cylinder(d1=2*screw,d2=screw,h=screw/2);
}

module endcorner(thickness,wall,screw,width,length) {
  difference() {
    union() {
      linear_extrude(height=width+wall,convexity=2)polygon([[0,0],[wall,0],[wall,width],[wall-thickness,width],[wall-thickness,width+length],[-thickness,width+length],[-thickness,width-0.5*thickness],[0,width-1.5*thickness]]);
      linear_extrude(height=wall,convexity=2)polygon([[0,0],[wall+width,0],[wall+width,width+length],[-thickness,width+length],[-thickness,width-0.5*thickness],[0,width-1.5*thickness]]);
    }
    translate([wall+width/2,(width+length)*0.25,0])bohrung(screw=screw,wall=wall);
    translate([wall+width/2,(width+length)*0.75,0])bohrung(screw=screw,wall=wall);
    translate([0,0.5*width-0.75*thickness,width/2+wall])rotate([0,90,0])bohrung(screw=screw,wall=wall);
  }
}

module guide(wall,width,length,screw,offset) {
  difference() {
    union() {
      cube([wall,width+wall,guide_length]);
      cube([width+wall+offset,wall,guide_length]);
    }
    translate([wall+width/2+offset,0,guide_length-width/2])rotate([-90,0,0])bohrung(screw=screw,wall=wall);
    translate([wall+width/2+offset,0,width/2])rotate([-90,0,0])bohrung(screw=screw,wall=wall);
  }
}

if (part=="upper-right") rotate([90,0,0]) endcorner(thickness=thickness,wall=wall,screw=screw,width=width,length=upper_length);
if (part=="upper-left") mirror([1,0,0]) rotate([90,0,0]) endcorner(thickness=thickness,wall=wall,screw=screw,width=width,length=upper_length);
if (part=="lower-left") rotate([90,0,0]) endcorner(thickness=thickness,wall=wall,screw=screw,width=width,length=lower_length);
if (part=="lower-right") mirror([1,0,0]) rotate([90,0,0]) endcorner(thickness=thickness,wall=wall,screw=screw,width=width,length=lower_length);
if (part=="guide") guide(wall=wall,width=width,length=guide_length,screw=screw,offset=thickness+wall);