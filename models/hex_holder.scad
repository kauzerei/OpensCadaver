include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fs=1/2;
$fa=1/2;
bsl=1/100;

hex_sizes=[1.5,2,2.5,3,4,5,6,8,9,10];

slack=0.3;
wall=1;
dist=0.4;
spring_width=0.5;
spring_length=10;
spring_max=0.7;
spring_min=0.5;
round_length=5;

last=len(hex_sizes)-1;
adjusted=[for (hex=hex_sizes) sqrt(4/3)*(hex+2*slack)];
widths=[for (d=adjusted) wall+2*dist+2*spring_width+d];
translations=cumsum([0, for (i=[0:1:last-1]) (widths[i]+widths[i+1])/2]);
thickness=max(adjusted)+2*wall;

beg=-widths[0]/2;
end=translations[last]+widths[last]/2;

module unit_holder(d,spring_width,spring_shape,spring_length,round_length,dist,thickness,wall) {
  //spring_dev=(1-sqrt(3/4))*d/2+spring_compression
  difference() {
    union() { //round holders
      translate([0,round_length/2+spring_length/2,0]) cube([d+2*spring_width+2*dist,round_length,thickness],center=true);
      translate([0,-round_length/2-spring_length/2,0]) cube([d+2*spring_width+2*dist,round_length,thickness],center=true);
    } //round holes
    rotate([-90,90,0]) cylinder(d=d,h=spring_length+2*round_length+bsl,center=true); //$fn=6 for hexagonal holes
  }
  translate([-d/2-spring_width-dist-wall/4,0,0]) cube([wall/2+bsl,2*round_length+spring_length,thickness],center=true);
  translate([d/2+spring_width+dist+wall/4,0,0]) cube([wall/2+bsl,2*round_length+spring_length,thickness],center=true);
  linear_extrude(height=thickness,center=true,convexity=4) {
    spring=smooth_path([[d/2+spring_width/2,-spring_length/2],
                        [d/2+spring_width/2-spring_shape,0],
                        [d/2+spring_width/2,spring_length/2]],method="edges",uniform=false,relsize=0.05);
    stroke(spring,width=spring_width);
    stroke(-spring,width=spring_width);
  }
}
a=atan(2*(end-beg)/(adjusted[last]-adjusted[0]))-90;
rotate([0,a,0]) intersection() {
  union() {
    for (i=[0:1:last]) translate([translations[i],0,0]) { //individual holders
      spring_shape=min((1-sqrt(3/4))*adjusted[i]/2+spring_max,0.5*adjusted[i]-spring_min/2);
      unit_holder(adjusted[i],spring_width,spring_shape,spring_length,round_length,dist,thickness,wall);
    }
    //extra wall behind the last
    translate([end,-spring_length/2-round_length,-thickness/2]) {
      cube([thickness,spring_length+2*round_length,thickness]);
    }
    //extra wall before the first
    translate([beg-thickness,-spring_length/2-round_length,-thickness/2]) {
      cube([thickness,spring_length+2*round_length,thickness]);
    }
  }
  hull() {
    translate([beg,0,0]) rotate([90,90,0]) cylinder(d=adjusted[0]+2*wall,h=spring_length+2*round_length,center=true);
    translate([end,0,0]) rotate([90,90,0]) cylinder(d=adjusted[last]+2*wall,h=spring_length+2*round_length,center=true);
  }
}

*unit_holder(4,0.5,1,20,10,1,10,2);