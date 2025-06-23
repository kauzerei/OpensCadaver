/* A tool to remove ignition coils from the N43 engine of E87
Printables descroption:
I designed this tool to remove ignition coils from the N43B20 engine of my E87.
It will also probably work on N43B16 engine and other BMWs with one of those engines.
It could potentially even work on other engines if you change the model parameters
(clip_size is the size of the ignition coil clip, which is the part, that this tool grabs),
but that's probably a stretch.
Some people are able to pull them with bare hands (but sometimes break the clips),
some use a screwdriver as a lever (which is barbaric and could damage insulation
or the plastic of the coil). I find it easier to have the perfect tool, since I'm
planning to stick with this engine for a while.
I used the initial version of this tool and it was hard to pull the third coil
without removing the tension brace (which requires outer torx bit and could be avoided),
so I made a longer version with shorter handle, but the longer version is yet untested.
*/
wall=4;
handle_length=75;
handle_width=70;
clip_size=[29,15,42];
cut=18;
echo(clip_size);
rotate([90,0,0]) {
  difference() {
    translate([0,0,0]) cube(clip_size+[2*wall,wall,wall]);
    translate([wall,wall+1/100,wall+1/100]) cube(clip_size);
    translate([2*wall,-1/100,-1/100]) cube([clip_size[0]-2*wall,clip_size[0]+wall+2/100,cut]);
  }
  hull() {
    translate([0,0,clip_size[2]+wall]) cube([wall,clip_size[1]+wall,wall]);
    translate([(clip_size[0]+2*wall)/2,(clip_size[1]+wall)/2,clip_size[2]+2*wall+clip_size[0]/2])
      rotate([0,0,360/16])
        cylinder(d=(clip_size[1]+wall)/cos(360/16),h=1/100,$fn=8);
  }
  hull() {
    translate([clip_size[0]+wall,0,clip_size[2]+wall]) cube([wall,clip_size[1]+wall,wall]);
    translate([(clip_size[0]+2*wall)/2,(clip_size[1]+wall)/2,clip_size[2]+2*wall+clip_size[0]/2])
      rotate([0,0,360/16])
        cylinder(d=(clip_size[1]+wall)/cos(360/16),h=1/100,$fn=8);
  }
  translate([(clip_size[0]+2*wall)/2,(clip_size[1]+wall)/2,clip_size[2]+2*wall+clip_size[0]/2])
    rotate([0,0,360/16])
      cylinder(d=(clip_size[1]+wall)/cos(360/16),h=handle_length,$fn=8);
  translate([(clip_size[0]+2*wall)/2,(clip_size[1]+wall)/2,clip_size[2]+2*wall+clip_size[0]/2+handle_length])
    rotate([0,90,0])rotate([0,0,360/16])
      cylinder(d=(clip_size[1]+wall)/cos(360/16),h=handle_width,$fn=8,center=true);
}