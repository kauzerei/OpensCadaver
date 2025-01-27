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