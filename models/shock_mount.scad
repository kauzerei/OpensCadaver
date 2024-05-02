$fa = 1 / 1;
$fs = 1 / 2;
bissl = 1 / 100;

part = "NOSTL_all"; //[inner_mount,outer_mount,inner_beam,outer_beam]

/*[general]*/
wall = 3;          // wall thickness
n_beams = 5;       // number of beams each tube has
cable_d = 3;       // inner diameter of hooks
wiggle_room = 0.4; // extra space for gluing

/*[inner mount dimensions]*/
inner_id = 60;     // inner diameter of inner tube
inner_length = 20; // length of inner tube
inner_beams = 60;  // length of mounting beams on inner tube
inner_bend = -15;  // angle of inner beams to the tube axis

/*[outer mount dimensions]*/
outer_id = 90;     // inner diameter of outer tube
outer_length = 20; // length of outer tube
outer_beams = 60;  // length of mounting beams on outer tube
outer_bend = 30;   // angle of outer beams to the tube axis

module hook(a = 120) {
  difference() {
    circle(d = 2 * wall + cable_d);
    circle(d = cable_d);
    polygon(points =
                [
                  [ 0, 0 ], for (i = [0:a])[(wall + cable_d) * sin(i),
                                            (wall + cable_d) * cos(i)]
                ],
            paths = [ [ for (i=[0:a]) i ] ]);
  }
  translate(
      [ (cable_d / 2 + wall / 2) * sin(a), (cable_d / 2 + wall / 2) * cos(a) ])
      circle(d = wall);
  translate([ 0, cable_d / 2 + wall / 2 ]) circle(d = wall);
  translate([ -wall / 2, (cable_d / 2 + wall / 2) * cos(0) ])
      square([ wall, wall / 2 ]);
}

module bent_hook(l = 50, stoppers = 30, bend) {
  rotate(-bend) {
    translate([ -wall / 2, 0 ]) square([ wall, (l - stoppers) / 2 ]);
    translate([ 0, cable_d / 2 + wall + (l - stoppers) / 2 ]) mirror([ 0, 1 ])
        hook();
  }
}

module beam(l = 50, stoppers = 30, bend = bend) {
  linear_extrude(height = wall, center = true) {
    for (m = [ [ 0, 0 ], [ 0, 1 ] ])
      mirror(m) {
        // translate([0,stoppers/2])bent_hook(l=l,stoppers=stoppers,bend=bend);
        translate([ 0, stoppers / 2 ])
            bent_hook(l = l, stoppers = stoppers, bend = bend);
        polygon(points =
                    [
                      [ 0, stoppers / 2 ], [ -1.5 * wall, stoppers / 2 ],
                      [ wall * tan(bend), stoppers / 2 + wall ]
                    ],
                paths = [[ 0, 1, 2 ]]);
      }
    hull() {
      translate([ 0, stoppers / 2 ]) circle(d = wall);
      translate([ 0, -stoppers / 2 ]) circle(d = wall);
    }
  }
}

module inner_shell(n = n_beams) {
  linear_extrude(inner_length, center = true) difference() {
    union() {
      circle(d = inner_id + 2 * wall);
      for (a = [0:360 / n:360])
        rotate(a) translate([ inner_id / 2, 0 ]) minkowski() {
          square([ 2 * wall + 2 * wiggle_room, wall + 2 * wiggle_room ],
                 center = true);
          circle(d = 2 * wall);
        }
    }
    circle(d = inner_id);
    for (a = [0:360 / n:360])
      rotate(a) translate([ inner_id / 2, 0 ])
          square([ 2 * wall + 2 * wiggle_room, wall + 2 * wiggle_room ],
                 center = true);
  }
}

module outer_shell(n = n_beams, d = outer_id, l = outer_length) {
  linear_extrude(l, center = true, convexity = 3) {
    difference() {
      circle(d = d + 2 * wall);
      circle(d = d);
      for (a = [0:360 / n:360])
        rotate(a) translate([ d / 2 + wall, 0 ])
            square([ 2 * wall + 2 * wiggle_room, wall + 2 * wiggle_room ],
                   center = true);
    }
    intersection() {
      circle(d = d + 2 * wall);
      for (a = [0:360 / n:360])
        rotate(a) translate([ d / 2 + wall, 0 ]) difference() {
          minkowski() {
            square([ 2 * wall + 2 * wiggle_room, wall + 2 * wiggle_room ], center = true);
            circle(d = 2 * wall);
          }
          square([ 2 * wall + 2 * wiggle_room, wall + 2 * wiggle_room ], center = true);
        }
    }
  }
}

module assembly() {
  inner_mount();
  for (a = [0:360 / n_beams:360])
    rotate([ 0, 0, a ]) translate([ inner_id / 2 + wall / 2, 0, 0 ])
        rotate([ 90, 0, 180 ])
            beam(l = inner_beams, stoppers = inner_length + 2 * wiggle_room,
                 bend = inner_bend);
  rotate([ 0, 0, -180 / n_beams ]) outer_mount();
  for (a = [-180 / n_beams:360 / n_beams:360])
    rotate([ 0, 0, a ]) translate([ outer_id / 2 + wall / 2, 0, 0 ])
        rotate([ 90, 0, 0 ])
            beam(l = outer_beams, stoppers = outer_length + 2 * wiggle_room,
                 bend = outer_bend);
}

module inner_mount(distance = 14) {
  inner_shell();
  difference() {
    hull() {
      for (tr =
               [[distance, -sqrt((inner_id / 2 + wall / 2) ^ 2 - distance ^ 2)],
                [distance, sqrt((inner_id / 2 + wall / 2) ^ 2 - distance ^ 2)]])
        translate(tr) cylinder(h = inner_length, d = wall, center = true);
    }
    rotate([ 0, 90, 0 ]) cylinder(d = 8, h = distance + wall / 2 + bissl);
  }
}

module outer_mount() {
  difference() {
    outer_shell();
    rotate([ 0, 90, 180 / n_beams ])
        cylinder(d = 8, h = outer_id / 2 + wall + bissl);
  }
}

if (part == "inner_mount") inner_mount();
if (part == "outer_mount") outer_mount();
if (part == "inner_beam") beam(l = inner_beams, stoppers = inner_length + 2 * wiggle_room,
       bend = inner_bend);
if (part == "outer_beam") beam(l = outer_beams, stoppers = outer_length + 2 * wiggle_room,
       bend = outer_bend);
if (part == "NOSTL_all") assembly();