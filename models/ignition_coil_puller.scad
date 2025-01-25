wall=4;
length=50;
rotate([90,0,0]) {
  difference() {
    translate([0,0,0]) cube([29+2*wall,15+wall,42+wall]);
    translate([wall,wall+1/100,wall+1/100]) cube([29,15,42]);
    translate([2*wall,-1/100,-1/100]) cube([29-2*wall,15+wall+2/100,18]);
  }
  hull() {
    translate([0,0,42+wall]) cube([wall,15+wall,wall]);
    translate([(29+2*wall)/2,(15+wall)/2,42+2*wall+29/2])rotate([0,0,360/16])cylinder(d=(15+wall)/cos(360/16),h=1/100,$fn=8);
  }
  hull() {
    translate([29+wall,0,42+wall]) cube([wall,15+wall,wall]);
    translate([(29+2*wall)/2,(15+wall)/2,42+2*wall+29/2])rotate([0,0,360/16])cylinder(d=(15+wall)/cos(360/16),h=1/100,$fn=8);
  }
  translate([(29+2*wall)/2,(15+wall)/2,42+2*wall+29/2])rotate([0,0,360/16])cylinder(d=(15+wall)/cos(360/16),h=length,$fn=8);
  translate([(29+2*wall)/2,(15+wall)/2,42+2*wall+29/2+length])rotate([0,90,0])rotate([0,0,360/16])cylinder(d=(15+wall)/cos(360/16),h=2*length,$fn=8,center=true);
}