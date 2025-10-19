// Case for DSO138

// Initially designed by Egil Kvaleberg, Apr 2015
// Remixed by sefiwhfiuewhb, February 2020
// Remixed by kauzerei, October 2025

// Made to be used with single 18650 cell and popular boost converter board
// No charger, because it's easier for me to just swap cells when discharged
// But there's plenty of space to build a charging board in
  
part = "top"; // [ demo, all, top, bottom, button, button2, slider, slider2, NOSTL_demo ]

buttonHole = [13, 8.3];

pcb = [4.6*25.4+0.2, 3*25.4+0.2, 1.1];
pcbmntdia = 1*3.1;
pcbthrdia = 4.0; // for threads // Edited CL was 2.6
pcbmntdx = pcb[0]-3.5*2-3.1; // Edited CL was 4.4
pcbmntdy = pcb[1]-3.5*2-3.1; // Edited CL was 3.4

batt = [26.3, 54.0, 17.0]; // 9 V battery with contact
extra_width=26.3;
lcdwinsize = [50.0+2, 37.0+2];
lcdpos = [pcb[0]/2-lcdwinsize[0]/2-27.5, 17.5-(pcb[1]/2-lcdwinsize[1]/2)]; // from lower right corner
lcdpcb = [53+2*10, 43+2*7]; // assume symmetrical, with margin
lcdframeh = 1*2.3; // frame height

ledpos = [pcb[0]/2-29.5, 8.0-pcb[1]/2]; // from lower right corner
leddia = 1*3.2;

pcb2bot = 4.0; // room from bottom pcb to bottom cover
pcb2lcd = 1*14.0; // room from top pcb to top LCD surface

buttonclearance = 0.2; //amount to subtract from button diameter for hole clearance Added by CL
buttoninsertheight = 11; //Added by CL - switched height for actuators to a separate variable to isolate from changes to main top case button cutout heights - actual height is this plus the radius of button because of sphere ontop

buttonrpos = [pcb[0]/2-20.0, 5.0-pcb[1]/2]; // from lower right corner, reset switch
button1pos = [pcb[0]/2-9.2, 18.0-pcb[1]/2]; // from lower right corner, other switches
buttondy = 38.0/3;
buttondia = 6.0;
buttonheight = 6+0.8; // above PCB, plus some extra tolerance //Edited by CL was 4.9

slider1pos = [12.9-pcb[0]/2, 18.0-pcb[1]/2]; // from lower left corner //Edited CL first number was 13.5
sliderdy = (42.4-7.0)/2;
sliderdx = (9.6-5.4)/2 + 0.5; // add tolerance 
sliderdia = 6.0;
sliderheight = 1*4.5; // above PCB
slidersq = 2.0+0.2; // size of square slider button (with some extra tolerance) //Edited by CL from +.2 to +.1

trimmer1pos = [23.5-pcb[0]/2, 44.7-pcb[1]/2]; // from lower left corner
trimmerdy = 53.3-44.7;
trimmerdia = 4; //Edited by CL was 3.1
trimmerheight = 1*6.6; // above PCB //Edited by CL was 4.6

bncpos = 15.8-pcb[0]/2; // from upper left corner
bncdia = 9.6+1.0; // 1.0 is extra margin

testpos = pcb[0]/2-39.3; // from upper right corner
testpdx = 1*5.5;
testpdy = 1*5.0;

powerpos = pcb[0]/2-20.9; // from upper right corner
powerdx = 1*9.0;
powerdz = 1*11.0;

usbpos = pcb[0]/2-57.5; // from lower right corner // Added by CL
usbdx = 1*9;
usbdz = 1*4.2;


switchneck = 6.0; // neck of toggle switch
switchbody = 15.0; // height of switch body, including contacts

wall = 1.2;
caser = wall;
twall = 1.2; // wall size of top - gets a bit flimsy if too thin
bwall = 2.0; // wall size of bottom - gets a bit flimsy if too thin

tol = 0.25;
d = 0.01;

bsl=1/100;
//real2bot = max(pcb2bot, batt[2]-pcb[2]-pcb2lcd-(twall-wall)); 
real2bot = pcb2bot; // BUG: assumes pcb2lcd0+pcb[2]+pcb2bot is greater than batt[2]

module nut(af, h) { // af is 2*r
	cylinder(r=af/2/cos(30), h=h, $fn=6);
}

module c_cube(x, y, z) {
	translate([-x/2, -y/2, 0]) cube([x, y, z]);
}

module cr_cube(x, y, z, r) {
	hull() {
		for (dx=[-1,1]) for (dy=[-1,1]) translate([dx*(x/2-r), dy*(y/2-r), 0]) cylinder(r=r, h=z, $fn=20);
	}
}

module cr2_cube(x, y, z, r1, r2) {
	hull() {
		for (dx=[-1,1]) for (dy=[-1,1]) translate([dx*(x/2-r1), dy*(y/2-r1), 0]) cylinder(r1=r1, r2=r2, h=z, $fn=20);
	}
}

module pcb_holder(w,h,t,wall) {
  linear_extrude(height=h) {
    difference() {
      square([t+wall,w+2*wall]);
      translate([0,wall]) square([t,w]);
      translate([0,2*wall]) square([t+wall,w-2*wall]);
    }
  }  
}

module spring_cutout(sd,st,sw,sh,bd,w) {
  cutout=(bd-sh)/2;
  translate([0,-sw/2,cutout])cube([st,sw,bd-cutout+bsl]);
  translate([0,-sw/2,bd-cutout])cube([st+wall+bsl,sw,cutout+bsl]);
  translate([0,-sw/2+w,0])cube([st+wall+bsl,sw-2*w,bd+bsl]);
}

module single_cell(bd,bl,sd,st,sw,sh,w,b) {
arc_depth=0.75*bd;
arc_width=0.8*bl;
arc_r=(arc_width^2+4*arc_depth^2)/arc_depth/8;
  difference() {
    cube([bl+2*sd+2*w,bd+wall,bd+b]);
    translate([w+st+w,0-bsl,b-bsl]) cube([bl+2*sd-2*st-2*w,bd+2*bsl,bd+bsl+2*bsl]);
    translate([w,bd/2,b])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w);
    translate([bl+2*sd+w,bd/2,b])rotate([0,0,180])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w);
*    translate([bl/2+sd+w,-bsl,bd+b+arc_r-arc_depth])rotate([-90,0,0])cylinder(r=arc_r,h=bd+2*w+2*bsl);
  }
}

module top() {
	sidewalls();
  *translate([pcb[0]/2+tol+wall, -pcb[1]/2-wall,wall]) {
    rotate([180,0,90])single_cell(bd=19,bl=65.4,sd=5,st=1.3,sw=7,sh=14.5,w=wall,b=0);
  }
  *translate([pcb[0]/2+tol+wall+19+2.5+4+wall, -10,wall]) {
    rotate([0,180,0]) pcb_holder(38,18,2.5,wall);
	}
  difference() {
		union() {
			 translate([batt[0]/2+tol+wall/2, 0, 0]) {
				cr_cube(pcb[0]+2*wall+2*tol+batt[0]+wall+2*tol, pcb[1]+2*wall+2*tol, twall, caser);
			}
			// PCB upper supports
			for (dx=[pcbmntdx/2, -pcbmntdx/2]) for (dy=[pcbmntdy/2, -pcbmntdy/2]) {
				translate([dx, dy, -(pcb2lcd-tol)]) {
					cylinder(r1=pcbthrdia/2+wall, r2=pcbthrdia/2+3*wall, h=pcb2lcd, $fn=20);
					// strengthening bars
					translate([0, sign(dy)*(2*d+tol+pcb[1]/2-pcbmntdy/2)/2, 0]) c_cube(wall, 2*d+tol+pcb[1]/2-pcbmntdy/2, pcb2lcd); 
					translate([sign(dx)*(2*d+tol+pcb[0]/2-pcbmntdx/2)/2, 0, 0]) c_cube(2*d+tol+pcb[0]/2-pcbmntdx/2, wall, pcb2lcd);
				}
			}
			// LED frame and cone
			translate([ledpos[0], ledpos[1], -(lcdframeh-tol)]) {
				cylinder(r=leddia/2+tol/2+wall, h=lcdframeh+d, $fn=20);
			}
			translate([ledpos[0], ledpos[1], -(pcb2lcd-buttonheight-wall)]) {
				cylinder(r1=leddia+tol+wall, r2=leddia/2+tol+wall, h=d+pcb2lcd-buttonheight-wall-lcdframeh, $fn=20);
			}

			// button frames
			for (dy=[0,3]) translate([button1pos[0], button1pos[1]+dy*buttondy, -(pcb2lcd-buttonheight-tol)]) {
				cylinder(r = buttondia/2+tol+wall, h=(pcb2lcd-buttonheight-tol)+d, $fn=60);
			}
			hull () for (dy=[1,2]) translate([button1pos[0], button1pos[1]+dy*buttondy, -(pcb2lcd-buttonheight-tol)]) {
				cylinder(r = buttondia/2+tol+wall, h=(pcb2lcd-buttonheight-tol)+d, $fn=60);
			}

			translate([buttonrpos[0], buttonrpos[1], -(pcb2lcd-buttonheight-tol)]) {
				cylinder(r = buttondia/2+tol+wall, h=(pcb2lcd-buttonheight-tol)+d, $fn=60);
			}
			// slider frames
			for (dy=[0,1,2]) translate([slider1pos[0], slider1pos[1]+dy*sliderdy, -(pcb2lcd-sliderheight-wall-tol)]) {
				hull() {
					for (dx=[-sliderdx,sliderdx]) translate([dx, 0, 0]) cylinder(r = sliderdia/2+tol+wall, h=(pcb2lcd-sliderheight-wall-tol)+d, $fn=60);
				}
			}
			// trimmer frame
			for (dy=[0,1]) translate([trimmer1pos[0], trimmer1pos[1]+dy*trimmerdy, -(pcb2lcd-trimmerheight-tol)]) cylinder(r=trimmerdia/2+tol/2+wall, h=pcb2lcd-trimmerheight-tol+d, $fn=20);

		}
		union () { // subtract:
			// LCD window
			translate([lcdpos[0], lcdpos[1], -d]) cr2_cube(lcdwinsize[0], lcdwinsize[1], d+twall+d, 0.1, twall/2);
			// LED hole and cone
			translate([ledpos[0], ledpos[1], -pcb2lcd]) cylinder(r=leddia/2+tol/2, h=pcb2lcd+twall+d, $fn=20);
			translate([ledpos[0], ledpos[1], -(pcb2lcd-buttonheight-wall)-d]) {
				cylinder(r1=leddia+tol, r2=leddia/2+tol, h=2*d+pcb2lcd-buttonheight-wall-lcdframeh, $fn=20);
			}
			// button holes
			for (dy=[0,3]) translate([button1pos[0], button1pos[1]+dy*buttondy, -pcb2lcd]) {
				cylinder(r = buttondia/2+tol, h=pcb2lcd+twall+d, $fn=60);
			}
			hull () for (dy=[1,2]) translate([button1pos[0], button1pos[1]+dy*buttondy, -pcb2lcd]) {
				cylinder(r = buttondia/2+tol, h=pcb2lcd+twall+d, $fn=60);
			}

			translate([buttonrpos[0], buttonrpos[1], -pcb2lcd]) {
				cylinder(r = buttondia/2+tol, h=pcb2lcd+twall+d, $fn=60);
			}
			// slider holes
			for (dy=[0,1,2]) translate([slider1pos[0], slider1pos[1]+dy*sliderdy, -pcb2lcd]) {
				hull() {
					for (dx=[-sliderdx,sliderdx]) translate([dx, 0, 0]) cylinder(r = sliderdia/2+tol, h=pcb2lcd+twall+d, $fn=60);
				}
			}
			// trimmer hole
			for (dy=[0,1]) translate([trimmer1pos[0], trimmer1pos[1]+dy*trimmerdy, -pcb2lcd]) cylinder(r=trimmerdia/2+tol/2, h=pcb2lcd+twall+d, $fn=20);
			// LCD pcb
			translate([lcdpos[0], lcdpos[1], -pcb2lcd]) c_cube(lcdpcb[0], lcdpcb[1], pcb2lcd-lcdframeh);

			screws();
			
			for (dx=[pcbmntdx/2, -pcbmntdx/2]) for (dy=[pcbmntdy/2, -pcbmntdy/2]) {
				translate([dx, dy, -(d+pcb2lcd+pcb[2])]) {
					cylinder(r=pcbthrdia/2, h=pcb2lcd+pcb[2]+twall-wall, $fn=20);
				}
			}
		}
	}	
}

module sidewalls() {
	difference() {
		#translate([0, 0, -(bwall+real2bot+pcb[2]+pcb2lcd)]) {
			translate([batt[0]/2+tol+wall/2, 0, 0]) {
				cr2_cube(pcb[0]+2*wall+2*tol+batt[0]+wall+2*tol, pcb[1]+2*wall+2*tol, (bwall+real2bot+pcb[2]+pcb2lcd+twall), caser, caser);
			}
		}
		union() { // subtract:
			// room for bottom lid
			translate([batt[0]/2+tol+wall/2, 0, -real2bot-pcb[2]-pcb2lcd-bwall-d]) cr_cube(pcb[0]+2*tol+batt[0]+wall+2*tol, pcb[1]+2*tol, d+bwall+tol, caser/2); 
			// room for everything in top wall
			translate([batt[0]/2+tol+wall/2, 0, -d]) cr_cube(pcb[0]+2*wall+4*tol+batt[0]+wall+2*tol, pcb[1]+batt[1]+2*wall+4*tol, twall+2*d, caser+tol);
			// room for pcb
			translate([0, 0, -real2bot-pcb[2]-pcb2lcd]) c_cube(pcb[0]+2*tol, pcb[1]+2*tol, real2bot+pcb[2]+pcb2lcd+d); 

			translate([pcb[0]/2+batt[0]/2+2*tol+wall, 0, -real2bot-pcb[2]-pcb2lcd]) c_cube(batt[0]+2*tol, pcb[1]+2*tol, real2bot+pcb[2]+pcb2lcd+d); // room for battery

			// BNC hole
			translate([bncpos, pcb[1]/2, -pcb2lcd+bncdia/2]) rotate([-90,0,0]) {
				cylinder(r=bncdia/2+tol, h=tol+wall+2*d, $fn=60); 
				// also cut out bottom...
				translate([0, 20.0/2, 0]) c_cube(bncdia+2*tol, 20.0, tol+wall+2*d);
			}

			// hole for test point
			translate([testpos, pcb[1]/2-testpdy, -pcb2lcd+pcb2lcd/2]) rotate([-90,0,0]) c_cube(testpdx, pcb2lcd, testpdy+tol+wall+d);


			// hole for USB connector
			translate([usbpos, -pcb[1], -pcb2lcd+usbdz/2]) rotate([-90,0,0]) c_cube(usbdx+2*tol, usbdz+2*tol, 40);

			// hole for power plug
			translate([powerpos, pcb[1]/2, -pcb2lcd+powerdz/2]) rotate([-90,0,0]) c_cube(powerdx+2*tol, powerdz+2*tol, tol+wall+d);
			// extra room for plug when installing pcb
			translate([powerpos, pcb[1]/2, -pcb2lcd+powerdz/2-pcb2bot-pcb[2]]) rotate([-90,0,0]) c_cube(powerdx+2*tol, powerdz+2*tol, tol+wall-0.45);

		  switchhole();
			translate([pcb[0]/2, pcb[1]/2-12.0, -pcb2lcd]) hull () { // hole for battery wire
				rotate([0, 90, 0]) cylinder(r=2.5/2, h=tol+wall+tol, $fn=10);
				translate([0, 0, -pcb2bot]) rotate([0, 90, 0]) cylinder(r=2.5/2, h=tol+wall+tol, $fn=10);
			}
		}
	}

	// enclosure for test point
	difference() {
		translate([testpos, pcb[1]/2-testpdy-wall, -pcb2lcd+pcb2lcd/2+tol]) rotate([-90,0,0]) c_cube(testpdx+2*wall, pcb2lcd, wall+testpdy+tol);
		translate([testpos, pcb[1]/2-testpdy, -pcb2lcd+pcb2lcd/2]) rotate([-90,0,0]) c_cube(testpdx, pcb2lcd, testpdy+tol+wall+d);
	}
}

module bottom() {
	module support(dx, dy, tap) {
		translate([dx, dy, -(d+real2bot+pcb[2]+pcb2lcd)]) {
			cylinder(r1=pcbmntdia/2+2.2*wall, r2=pcbmntdia/2+wall, h=d+real2bot, $fn=20); // support cylinder for screws
			if (tap > 0) cylinder(r=pcbmntdia/2-tol, h=d+real2bot+tap, $fn=20);
		}
	}
	difference() {
		union () {
			// bottom lid
			translate([0, 0, -(bwall+real2bot+pcb[2]+pcb2lcd)]) {
				translate([batt[0]/2+tol+wall/2, 0, 0]) {
					cr_cube(pcb[0]+batt[0]+wall+2*tol, pcb[1], bwall, caser/2);
				}
			}
			intersection () {
				translate([0, 0, -(real2bot+pcb[2]+pcb2lcd)]) {
					translate([batt[0]/2+tol+wall/2, 0, 0]) cr_cube(pcb[0]+batt[0]+wall+2*tol, pcb[1], real2bot+pcb[2], caser/2);
				}
				union () {	
					for (dx=[pcbmntdx/2, -pcbmntdx/2]) for (dy=[pcbmntdy/2, -pcbmntdy/2]) {
						support(dx, dy, 0);	
					}
				}
			}
		}
		screws();
	}

	// BNC lower part, minus hole
	translate([bncpos, pcb[1]/2, -pcb2lcd-pcb[2]-real2bot-bwall]) c_cube(bncdia, 2*(tol+wall), bwall);
	difference () {
		translate([bncpos, pcb[1]/2+tol, -pcb2lcd-pcb[2]-real2bot-bwall+(real2bot+bwall+bncdia/2)/2]) rotate([-90,0,0]) c_cube(bncdia, (real2bot+bwall+bncdia/2), wall); 

		translate([bncpos, pcb[1]/2, -pcb2lcd+bncdia/2]) rotate([-90,0,0]) cylinder(r=bncdia/2+tol, h=tol+wall+d, $fn=60); 
	}
}


module screws() {
	for (dx=[pcbmntdx/2, -pcbmntdx/2]) for (dy=[pcbmntdy/2, -pcbmntdy/2]) { // screw?
		translate([dx, dy, -(real2bot+pcb[2]+pcb2lcd+bwall+d)]) {
			cylinder(r1=pcbmntdia+.4, r2=0, h=pcbmntdia+1, $fn=20); // countersink recess //Edited by CL increase recess size
			cylinder(r=pcbmntdia/2+tol, h=d+bwall+real2bot+d, $fn=20);
		}
	}
}

module switchhole() {
  translate([pcb[0]/2+tol+wall+19+2.5+4+wall, -24,-10]) {
    rotate([0,90,0]) linear_extrude(height=wall+tol) {
      square([4,8],center=true);
      translate([0,7.5]) circle(d=3);
      translate([0,-7.5]) circle(d=3);    
    }
  }
}


module button() {
	cylinder(r = buttondia/2+tol+wall, h=wall, $fn=60);

	translate([0, 0, wall/2]) cylinder(r = buttondia/2-buttonclearance, h=buttoninsertheight-.3, $fn=60);
	translate([0, 0, buttoninsertheight]) sphere(r = buttondia/2-buttonclearance, $fn=60);
}

module button2() {
	ro = 2.5; // rotation allowance 
	hull() {
		cylinder(r = buttondia/2+tol+wall, h=wall, $fn=60); //outer base / brim of button
		translate([0, buttondy, 0]) cylinder(r = buttondia/2+tol+wall, h=wall, $fn=60);
	}
	translate([0, 0, wall/2]) hull() {
		rotate([-ro, 0, 0]) cylinder(r = buttondia/2-buttonclearance, h=buttoninsertheight-.6, $fn=60); //left side cylinder
		translate([0, buttondy, 0]) rotate([ro, 0, 0]) cylinder(r = buttondia/2-buttonclearance, h=buttoninsertheight-.6, $fn=60); //right side cylinder
	}
	hull() {
		rotate([-ro, 0, 0]) translate([0, 0, buttoninsertheight]) sphere(r = buttondia/2-buttonclearance, $fn=60); //top left sphere
		translate([0, buttondy/2, buttoninsertheight]) cylinder(r = buttondia/2-buttonclearance, h=d, $fn=60);
	}
	hull() {
		translate([0, buttondy/2, buttoninsertheight]) cylinder(r = buttondia/2-buttonclearance, h=d, $fn=60); //top right sphere
		translate([0, buttondy, 0]) rotate([ro, 0, 0]) translate([0, 0, buttoninsertheight]) sphere(r = buttondia/2-buttonclearance, $fn=60);
	}
}

module slider() {
	difference() {
		union() {
			hull() {
				for (dx=[-2*sliderdx, 2*sliderdx]) translate([dx, 0, 0]) cylinder(r = sliderdia/2+tol+wall, h=wall, $fn=60);
			}
			cylinder(r = sliderdia/2-buttonclearance, h=buttoninsertheight, $fn=60);
			translate([0, 0, buttoninsertheight]) sphere(r = buttondia/2-buttonclearance, $fn=60);
		}
		translate([0, 0, -d]) {
			c_cube(slidersq+tol, slidersq+tol, pcb2lcd-sliderheight);
			c_cube(slidersq+2*tol, slidersq+2*tol, 2*tol); // avoid brim effect
		}
	}
}

// upper slider that interferes with trimmer
module slider2() {
	difference() {
		union() {
			hull() {
				c_cube(sliderdia+2*tol+2*wall, sliderdia+2*tol+2*wall, wall);
				translate([-2*sliderdx, 0, 0]) cylinder(r = sliderdia/2+tol+wall, h=wall, $fn=60);
			}
			cylinder(r = sliderdia/2-buttonclearance, h=buttoninsertheight, $fn=60);
			translate([0, 0, buttoninsertheight]) sphere(r = buttondia/2-buttonclearance, $fn=60);
		}
		translate([0, 0, -d]) {
			c_cube(slidersq+tol, slidersq+tol, pcb2lcd-sliderheight);
			c_cube(slidersq+2*tol, slidersq+2*tol, 2*tol); // avoid brim effect
		}
	}
}

if (part=="demo") top();
if (part=="top") rotate([180, 0, 0]) top();
//if (part=="top") top();

if (part=="demo" || part=="bottom") bottom();

if (part=="button") button(); // three of these
if (part=="button2") button2();
if (part=="slider") slider(); // two of these
if (part=="slider2") slider2();

if (part=="demo" || part=="buttons") color("red") { 
	translate ([button1pos[0], button1pos[1]+0*buttondy, -(pcb2lcd-buttonheight-tol)]) button(); // three of these
	translate ([button1pos[0], button1pos[1]+3*buttondy, -(pcb2lcd-buttonheight-tol)]) button();
	translate ([buttonrpos[0], buttonrpos[1], -(pcb2lcd-buttonheight-tol)]) button(); 
	translate ([button1pos[0], button1pos[1]+1*buttondy, -(pcb2lcd-buttonheight-tol)]) button2(); 
	translate ([slider1pos[0], slider1pos[1]+0*sliderdy, -(pcb2lcd-sliderheight-tol)]) slider(); // two of these
	translate ([slider1pos[0], slider1pos[1]+1*sliderdy, -(pcb2lcd-sliderheight-tol)]) slider();
	translate ([slider1pos[0], slider1pos[1]+2*sliderdy, -(pcb2lcd-sliderheight-tol)]) slider2();
}

if (part=="all") {
	translate([-pcb[0]/2-wall-4, 0, bwall]) rotate([0, 180, 0]) top();
	translate([pcb[0]/2+wall+4, 0, pcb2lcd+pcb[2]+real2bot+wall+tol]) bottom();
}


