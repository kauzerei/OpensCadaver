wall=0.8;
width=30;
length=80;
height=15;

difference() {
  translate([-wall,-wall,-wall]) cube([length,width,height]);
  translate([0,0,0]) cube([length-2*wall,width-2*wall,height]);
}

