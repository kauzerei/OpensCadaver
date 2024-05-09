// Yet another parametric thumb screw head
// because I did not really like any of the screws I've seen on Thingiverse

bissl = 1 / 100;
$fa = 1 / 1;
$fs = 1 / 2;

n_lobes = 2;    // number of lobes
h_lobes = 15;   // height of vertical part of lobes
d_lobes = 7.5;  // roundness of lobes
l_lobes = 15;   // how far the lobes protrude from center
max_angle = 45; // maximal angle to print without supports

bolt_d = 5; // thread diameter
hex_d = 9;  // corner-to-corner size of the nut
wall = 3;   // thinnest part wall
base = 0;   // height of cylindrical base before tapering part

module thumb_screw(bolt_d, hex_d, wall = 3, base = 0, angle = 45, flap_n = 2,
                   flap_d, flap_l, flap_h) {
  flap_d = is_undef(flap_d) ? hex_d / 2 + wall : flap_d;
  flap_l = is_undef(flap_l) ? hex_d + 2 * wall : flap_l;
  flap_h = is_undef(flap_h) ? hex_d + 2 * wall : flap_h;
  cyl_d = hex_d + 2 * wall;
  h = ((flap_l - cyl_d / 2 - flap_d / 2) + (flap_d / 2) / cos(angle)) /
      tan(angle);
  difference() {
    union() {
      cylinder(d = cyl_d, h = base);
      translate([ 0, 0, base ]) hull() {
        cylinder(d = cyl_d, h = h);
        rotate_extrude(angle = 360, convexity = 1)
            translate([ cyl_d / 2 - wall, 2 * h + flap_h - flap_d - wall ])
                circle(r = wall);
        for (a = [0:360 / flap_n:360])
          rotate(
              [ 0, 0,
                a ]) for (tr =
                              [
                                //      [-flap_l+flap_d/2,0,h],
                                [ flap_l - flap_d / 2, 0, h ],
                                //      [-flap_l+flap_d/2,0,h+flap_h-flap_d],
                                [ flap_l - flap_d / 2, 0, h + flap_h - flap_d ],
                              ]) translate(tr) sphere(d = flap_d);
      }
    }
    translate([ 0, 0, -bissl ])
        cylinder(d = bolt_d, h = 2 * h + flap_h - flap_d + 2 * bissl + base);
    translate([ 0, 0, wall ]) cylinder(
        d = hex_d, h = 2 * h + flap_h - flap_d + 2 * bissl + base, $fn = 6);
  }
}
thumb_screw(bolt_d = bolt_d, hex_d = hex_d, wall = wall, base = base,
            angle = 45, flap_n = n_lobes, flap_d = d_lobes, flap_l = l_lobes,
            flap_h = h_lobes);
// thumb_screw(bolt_d=bolt_d,hex_d=hex_d,wall=wall,base=base,angle=45,flap_n=n_lobes);

// screw for vice
// thumb_screw(bolt_d=12,hex_d=12,wall=3,angle=45,flap_h=40);