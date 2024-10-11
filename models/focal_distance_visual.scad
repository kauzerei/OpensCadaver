format=[24,36];
//format=[56,56];
//format=[56,84];
height=40;
wall=2;
air=1;
thickness=8;
length=137;

module frame() {
  difference() {
    union() {
      translate([-format[0]/2-wall,-format[1]/2-wall,0]) cube ([format[0]+2*wall,format[1]+2*wall,wall]);
      translate([0,-thickness/2,0])cube([height,thickness,wall]);
    }
    translate([-format[0]/2,-format[1]/2,-1/100]) cube([format[0],format[1],wall+2/100]);
    translate([height-thickness,-thickness/4,-1/100]) cube([thickness+1/100,thickness/2,wall+2/100]);
  } 
}

module eyepiece() {
  difference() {
    union() {
      cylinder (d=2*thickness,h=wall);
      translate([0,-thickness/2,0])cube([height,thickness,wall]);
    }
    translate([0,0,-1/100])cylinder (d=thickness,h=wall+2/100);
    translate([height-thickness,-thickness/4,-1/100]) cube([thickness+1/100,thickness/2,wall+2/100]);
  } 
}

module stange() {
  difference() {
    cube([thickness,length,thickness]);
    for (tr=[wall:5:length]) {
      translate([3*thickness/4-air/2,tr,-1/100]) cube([thickness,wall+air,thickness+2/100]);
      translate([-3*thickness/4+air/2,tr,-1/100]) cube([thickness,wall+air,thickness+2/100]);
    }
  }
}

frame();
//eyepiece();
//stange();