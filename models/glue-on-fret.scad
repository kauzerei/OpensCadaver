$fs=1/2;
$fa=1/2;
$fn=32;

base_thickness=0.2;
base_width=8;

fret_length=55;
fret_height=1.2;
fret_width=3;

neutral_fret=8.5;
scale_bass=342*2;
scale_treble=324*2;
width_0=51;
width_24=74;
scale=(scale_treble+scale_bass)/2;
//frets=[for (i=[0.5:1:10.5]) i];
frets=[for (i=[11.5:1:23.5]) i];

function fret_coord(n)=scale*(1-pow(0.5,n/12));
function fret_length(coord)=lookup(coord,[[fret_coord(0),width_0],[fret_coord(24),width_24]]);

total_skew=(scale_bass-scale_treble)/2;
offset=total_skew*fret_coord(neutral_fret)/scale;

function skew(fret_coord)=total_skew*fret_coord/scale-offset;

for (fret=frets) translate([fret*(base_width+2),0,0]) fret(fret_length(fret_coord(fret)),skew(fret_coord(fret)));

module fret(length=fret_length,skew) multmatrix([[1,-2*skew/length,0,0],
                                                 [0,1,0,0],
                                                 [0,0,1,0],
                                                 [0,0,0,1]]){
  echo(length);
  intersection() {
    rotate([90,0,0]) linear_extrude(length, center=true) {
      scale([fret_width,fret_height*2])
      intersection() {
        circle(r=0.5);
        translate([-0.5,0]) square([1,0.5]);
      }
    }
    translate([0,0,base_thickness])linear_extrude(height=fret_height,scale=[1,(length-2*fret_height)/length]) square([base_width,length],center=true);
  }
  translate([-base_width/2,-length/2,0])cube([base_width,length,base_thickness]);
}
