$fs=1/2;
$fa=1/2;
bsl=1/100;

angle1=110;
angle2=85;
measured_thickness=8; //measured between flats, at angle to strings 
string_height=10; //measured in the middle at the thikest place
width=60; //fretboard width, measured at narrowest end
fillet=4;
chamfer=1;
radius=300; //fingerboard radius at nut in mm
headstock_angle=10;
offset_top=3;
offset_low=3;
string_gauges=[.010, .013, .017, .030, .042, .054, .064, .074];

function sum(list)=(len(list)==0)?0:list * [for(i = [1 : len(list)]) 1];

angle=(angle2-angle1)/2;
thickness=measured_thickness/cos(angle);
strings=string_gauges*25.4;
height=string_height+max(strings)/2;
spacing=(width-offset_top-offset_low-sum(strings))/(len(strings)-1);
center_distances=[for (i=[0:1:len(strings)-2]) strings[i]/2+strings[i+1]/2+spacing];
offsets=[for (i=[0:1:len(strings)-1]) offset_top+strings[0]/2+sum([for (j=[0:1:i-1]) center_distances[j] ])];

//for (i=[0:1:len(strings)-1]) translate([offsets[i],0,0]) cylinder(d=strings[i],h=50);
//echo(strings);
//echo(center_distances);
//echo(offsets);

module cross_section(w=thickness,h=height,r=2) {
  square([w-r,h]);
  square([w,h-r]);
  translate([w-r,h-r]) circle(r=r);
}

module slice() rotate([90,0,90]) linear_extrude(h=bsl,center=true) cross_section();

segments=128;
xpos=[for (x=[-width/2:width/segments:width/2]) x];
ypos=xpos*tan(angle);
zpos=[for (x=xpos) sqrt(radius*radius-x*x)-radius];
rot=[for (x=xpos) lookup(x,[[-width/2,90-(angle1+angle2)/2],[width/2,(angle1+angle2)/2-90]])];
xtoz=[for (i=[0:1:segments]) [xpos[i],zpos[i]]];

module cutout(d) {
  m=height;
  translate([-d/sqrt(2)+d/2,0]) rotate(-45) {
    translate([d/2,d/2])circle(d=d,$fn=32);
    polygon([[d/2,0],[m,0],[0,m],[0,d/2]]);
  }
}

r=thickness/sin(headstock_angle);

difference() {
  hull() 
    for (i=[0:1:segments]) translate([xpos[i],ypos[i],zpos[i]]) rotate([0,0,rot[i]]) {
    dist=width/2-abs(xpos[i]);
    echo(dist);
    sf=dist>=chamfer?[1,1,1]:[1,(thickness-chamfer+dist)/thickness,(height-chamfer+dist)/height];
    scale(sf) slice();
  }
  for (string=[0:1:len(strings)-1]) {
    x=width/2-offsets[string];
    rot=lookup(x,[[-width/2,90-(angle1+angle2)/2],[width/2,(angle1+angle2)/2-90]]);
    translate([x,x*tan(angle),-r+string_height+lookup(x,xtoz)]) rotate([0,0,rot]) rotate([0,90,0]) rotate_extrude(angle=360) translate([r,0]) cutout(strings[string]);
  }
  translate([-width,-width,-2*width])cube([2*width,2*width,2*width]);
}