part="coupling_gear";//[one_gear,rack,coupling_gear,worm_gear,reference]

/*constants*/
pi=355/113;
bissl=1/100; //a bissl, gell

/*gear parameters*/
od=41.7; //outer diameter
or=od/2;
id=36.6; //inner diameter
ir=id/2;
pitch_position=0.5; //where the pitch circle is between the top and bottom points of the teeth
pr=ir+pitch_position*(or-ir); //pitch radius
n=54; //number of teeth
da=0.18; //defines contact angle (pointiness of tooth)
dh=0.32;  //defines profile asymmetry (thinness of tooth)


iter=4; //iterations for approximating single tooth
sgn=54; //second gear number of teeth
sgr=pr*sgn/n; //second gear radius
tooth=2*pr*pi/n;
  
/*worm gear parameters*/
worm_iter=32; //iterations when approximating worm gear cross section
worm_thickness=10; //about half diameter of worm gear

module original_gear() {
  rotate([0,0,-4.9]) import(file="../import/settings.svg",center=true,dpi=500);
}

module apple_gear() {
  arr=[for (i=[0:1:n-1]) let(a=i*360/n) each [ir*[sin(a),cos(a)],
                                            or*[sin(a+360*da/n),cos(a+360*da/n)],
                                            or*[sin(a+dh*360/n),cos(a+dh*360/n)],
                                            ir*[sin(a+dh*360/n+da*360/n),cos(a+dh*360/n+da*360/n)]]];

  polygon(arr);
}

module rack(nteeth=5) { //warning, the teeth on ends are not fully correct, as they are cut from one side
  total_rot=nteeth*360/n;
  total_tr=2*pr*pi*total_rot/360; //how far the gear rolls
  tr=[for (x=[0:total_tr/(iter*nteeth):total_tr]) x];
  rot=[for (x=[0:total_rot/(iter*nteeth):total_rot]) x];
  difference() {
    translate([0,-ir-worm_thickness])square([total_tr,worm_thickness]);
    for (i=[0:1:iter*nteeth-1]) translate([tr[i],0,0]) rotate([0,0,-rot[i]]) apple_gear();
  }
}

module second_gear(iter=iter*sgn) {
  rot=[for (x=[0:360/iter:360]) x];
  difference() {
    circle(r=sgr+(or-ir));
    for (i=[0:1:iter-1]) rotate([0,0,-rot[i]*(pr/sgr)]) translate([sgr+pr,0,0]) rotate([0,0,-rot[i]]) apple_gear();
  }
}

module worm_section(nteeth=5) { //take a correctly shaped tooth from the middle of the rack, and wrap around a circle 
  for (i=[0:1:worm_iter-1]) {
    hull(){ //chain hull, because the shape can have convexities
      rotate([0,0,-180+i*360/worm_iter]) intersection() {
        translate([-(nteeth/2-0.5)*tooth-i*tooth/worm_iter,worm_thickness+ir]) rack();
        square([bissl,worm_thickness]);
      }
      rotate([0,0,-180+(i+1)*360/worm_iter]) intersection() {
        translate([-(nteeth/2-0.5)*tooth-(i+1)*tooth/worm_iter,worm_thickness+ir]) rack();
        square([bissl,worm_thickness]);
      }
    }
  } 
}

module worm(teeth=10) {
  linear_extrude(height=2*teeth*pr*pi/n,twist=360*teeth,$fn=worm_iter) worm_section();
}

if (part=="rack") {
  color([1,0.5,0.5]) linear_extrude(height=0.1,center=true) rotate([0,0,90])apple_gear();
//  color([0.5,0.5,1]) linear_extrude(height=2) translate([-2*pr*pi/4,0])rack(nteeth=n/2);
  color([0.5,0.5,1]) linear_extrude(height=0.1,center=true) translate([-pr*pi*7/n,0])rack(nteeth=7);
}

if (part=="coupling_gear") {
  color([0.5,0.5,1]) linear_extrude(height=2) second_gear();
  color([1,0.5,0.5]) linear_extrude(height=2) translate([pr+sgr,0,0]) apple_gear();
}

if (part=="worm_gear") {
  color([0.5,0.5,1]) translate([-10*tooth,-ir-worm_thickness,0])rotate([0,90,0])worm(20);
  color([1,0.5,0.5]) linear_extrude(height=2,center=true) rotate([0,0,90]) apple_gear();
}

if (part=="reference") {
  translate([or+sgr,0,0]) original_gear();
  color([0.5,0.5,1]) linear_extrude(height=2) second_gear();
}

if (part=="one_gear") rotate([0,0,4.9]) apple_gear();