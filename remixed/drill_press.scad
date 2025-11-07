$fs=1/2;
$fa=1/2;
bsl=1/100;
part="03-support";//[03-support,11-lever_end_ball,08-adjust_screw]

module ball() {
  difference() {
    intersection() {
      sphere(d=18);
      cylinder(d=18,h=13,center=true);
    }
    translate([0,0,0])cylinder(d=12,h=9,$fn=6);
    cylinder(d=6.2,h=18,center=true);
  }
}

module support() {
  rotate([90,0,0])import("/home/kauz/dev/OpensCadaver/import/03-support_dremel.stl");
  translate([-13,8,12.5])cube([10,10,10]);
  translate([-13,-18,12.5])cube([10,10,10]);
  translate([-39,0,-22.5]) difference() {
    cylinder(d=31,h=12);
    translate([0,0,5]) cylinder(d=20,h=7.01);
    translate([0,0,4]) cylinder(d1=18,d2=20,h=1.01);
    translate([0,0,-0.01]) cylinder(d=18,h=5.02);
    rotate([0,0,45]) translate([-40,-1,-1]) cube ([40,2,14]);
  }
}

module thumb_screw(bolt_d,hex_d,wall=3,angle=45,flap_d,flap_l,flap_h){
  flap_d=is_undef(flap_d)?hex_d/2+wall:flap_d;
  flap_l=is_undef(flap_l)?hex_d+2*wall:flap_l;
  flap_h=is_undef(flap_h)?hex_d+2*wall:flap_h;
  cyl_d=hex_d+2*wall;
  h=((flap_l-cyl_d/2-flap_d/2)+(flap_d/2)/cos(angle))/tan(angle);
  difference() {
    hull() {
      cylinder(d=cyl_d,h=h);
      rotate_extrude(angle=360,convexity=1) translate([cyl_d/2-wall,2*h+flap_h-flap_d-wall])circle(r=wall);
      for (tr=[
        [-flap_l+flap_d/2,0,h],
        [flap_l-flap_d/2,0,h],
        [-flap_l+flap_d/2,0,h+flap_h-flap_d],
        [flap_l-flap_d/2,0,h+flap_h-flap_d],
      ]) translate(tr) sphere (d=flap_d);
    }
    translate([0,0,-bsl])cylinder(d=bolt_d,h=100);
    translate([0,0,wall])cylinder(d=hex_d,h=100,$fn=6);
  }
}

if (part=="03-support") support();
if (part=="11-lever_end_ball") ball();
if (part=="08-adjust_screw") thumb_screw(bolt_d=5,hex_d=9,wall=3,angle=45);