part="one_gear";//[one_gear,rack,coupling_gear,worm_gear,reference]

/*gear parameters*/
od=41.7; //outer diameter
or=od/2;
id=36.6; //inner diameter
ir=id/2;
n=54; //number of teeth
da=0.18; //defines contact angle (pointiness of tooth)
dh=0.32;  //defines profile asymmetry (thinness of tooth)

iter=4; //iterations for approximating single tooth
sgn=50; //second gear number of teeth
sgr=or*sgn/n; //second gear radius

/*worm gear parameters*/
worm_iter=32; //iterations when approximating worm gear cross section
worm_thickness=10; //about half diameter of worm gear

/*constants*/
pi=355/113;
bissl=1/1000; //a bissl, gell

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

module rack(nteeth=n) { //warning, the teeth on ends are not fully correct, as they are cut from one side
  total_rot=nteeth*360/n;
  total_tr=od*pi*total_rot/360; //how far the gear rolls
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
    circle(r=sgr+2*(or-ir));
    for (i=[0:1:iter-1]) rotate([0,0,-rot[i]*(or/sgr)]) translate([sgr+or,0,0]) rotate([0,0,-rot[i]]) apple_gear();
  }
}

module worm_section(nteeth=5) { //take a correctly shaped tooth from the middle of the rack, and wrap around a circle 
  total_rot=nteeth*360/n;
  total_tr=od*pi*total_rot/360;
  tooth=total_tr/nteeth;
  for (i=[0:1:worm_iter-1]) {
    hull(){ //chain hull, because the shape can have convexities
      rotate([0,0,i*360/worm_iter]) intersection() {
        translate([-floor(nteeth/2)*tooth-i*tooth/worm_iter,worm_thickness+ir]) rack(nteeth);
        square([bissl,worm_thickness]);
      }
      rotate([0,0,(i+1)*360/worm_iter]) intersection() {
        translate([-floor(nteeth/2)*tooth-(i+1)*tooth/worm_iter,worm_thickness+ir]) rack(nteeth);
        square([bissl,worm_thickness]);
      }
    }
  } 
}

module worm() {
  linear_extrude(height=od*pi/2,twist=180*n,center=true,$fn=worm_iter) worm_section(nteeth=5);
}

if (part=="rack") {
  color([1,0.5,0.5]) linear_extrude(height=2) rotate([0,0,90])apple_gear();
  color([0.5,0.5,1]) linear_extrude(height=2) translate([-od*pi/4,0])rack(nteeth=n/2);
}

if (part=="coupling_gear") {
  color([0.5,0.5,1]) linear_extrude(height=2) second_gear();
  color([1,0.5,0.5]) linear_extrude(height=2) translate([or+sgr,0,0]) apple_gear();
}

if (part=="worm_gear") {
  color([0.5,0.5,1]) translate([ir+worm_thickness,0,0])rotate([0,90,90])worm();
  color([1,0.5,0.5]) linear_extrude(height=2,center=true) apple_gear();
}

if (part=="reference") {
  translate([or+sgr,0,0]) original_gear();
  color([0.5,0.5,1]) linear_extrude(height=2) second_gear();
}

if (part=="one_gear") rotate([0,0,4.9]) apple_gear();