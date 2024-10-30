//Box for RPi Pico with display
part="bottom"; //[bottom,top,button]
wall=1.5;
extra=4; //lip on the lid that presses top pcb down
thread=3;
air=0.5;
bissl=1/100;
button=4;
joystick=6;
height=16.8+air+extra;
width=52.4+1.5+2*air;
length=26.7+2*air;
$fa=1/1;
$fs=1/2;
module bottom() {
  difference() {
    cube([width+2*wall,length+4*wall+2*thread,height+wall]);
    translate([wall,2*wall+thread,wall])cube([width,length,height+bissl]);
    for (tr=[[wall+thread/2,wall+thread/2,height/2+wall],
             [wall+thread/2,length+3*wall+1.5*thread,height/2+wall],
             [width+wall-thread/2,wall+thread/2,height/2+wall],
             [width+wall-thread/2,length+3*wall+1.5*thread,height/2+wall]])
      translate(tr) cylinder(h=height/2+bissl,d=thread);
    translate([wall/2,2*wall+thread+length/2,3-bissl])cube([wall+bissl,8,6],center=true);
    translate([0,2*wall+thread+length/2,wall+7])rotate([0,90,0])cylinder(d=button,h=2*wall+bissl,center=true);
  }
}
module top() {
  difference() {
    cube([width+2*wall,length+4*wall+2*thread,wall]); 
    for (tr=[[wall+thread/2,wall+thread/2,-bissl],
             [wall+thread/2,length+3*wall+1.5*thread,-bissl],
             [width+wall-thread/2,wall+thread/2,-bissl],
             [width+wall-thread/2,length+3*wall+1.5*thread,-bissl]]) 
      translate(tr) cylinder(h=wall+2*bissl,d=thread);
    translate([wall+1.5,2*wall+thread,-bissl]) 
      for (tr=[[47.7+air,5.5+0],
               [47.7+air,5.5+5.7],
               [47.7+air,5.5+2*5.7],
               [47.7+air,5.5+3*5.7],
               [6.7+0.5,13.8+air]]) 
        translate(tr) cylinder(h=wall+2*bissl,d=button);
    translate([wall+1.5+6.7+air,2*wall+thread+13.8+air,-bissl]) cylinder(h=wall+2*bissl,d=joystick);
    translate([wall+13.5+1.5,2*wall+thread,-bissl])cube([31,27,wall+2*bissl]);
  }
  translate([wall+13.5+1.5-2,2*wall+thread,-extra])cube([2,27,extra]);
  translate([wall+13.5+1.5+31,2*wall+thread,-extra])cube([2,27,extra]);
}
module button() {
  cylinder(h=1,d=5);
  cylinder(h=5,d=3);
}
if (part=="bottom")bottom();
if (part=="top")rotate([180,0,0])top();
if (part=="button")button();