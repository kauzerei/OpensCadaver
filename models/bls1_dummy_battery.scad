//Battery adapter for Olympus cameras
//For powering the camera from external power source
bissl = 1 / 100;
part = "box"; //[box,cover,NOSTL_assembly]
height = 12.9;
width = 35.4;
length = 54.9;
wall = 0.8;
contact = 1.0;
wiggle_room = 0.0;
h = height - 2 * wiggle_room - wall;
w = width - 2 * wiggle_room;
l = length - 2 * wiggle_room;

module holder() {
  difference() {
    translate([ (contact + wall) / 2, 0, 0 ])
        cube([ contact + wall, 6 + 2 * wall, 8 ], center = true);
    translate([ contact / 2, 0, 0 ])
        cube([ contact + bissl, 6, 9 ], center = true);
  }
}

module battery() {
  difference() {
    union() {
      difference() {
        translate([ -l / 2, -w / 2, 0 ]) cube([ l, w, h ]);
        translate([ wall - l / 2, wall - w / 2, wall ])
            cube([ l - 2 * wall, w - 2 * wall, h ]);
      }
      translate([ -l / 2, -w / 2, 0 ]) cube([ 3 + wall, 4 + wall, 3 + wall ]);
    }
    translate([ -l / 2 - bissl, -w / 2 - bissl, -bissl ]) cube([ 3, 4, 3 ]);
    for (tr = [
           [ -l / 2 + wall / 2, 3, 5 ],
           //[-l/2+wall/2,-3,5],
           [ -l / 2 + wall / 2, -9, 5 ]
         ])
      translate(tr) cube([ wall + 2 * bissl, 4, 5 ], center = true);
    translate([ l / 2 - wall / 2, 0, h / 2 ]) rotate([ 0, 90, 0 ])
        cylinder(d = 6, h = wall + bissl, center = true);
  }
  for (tr = [ [ -l / 2 + wall, 3, 5 ], [ -l / 2 + wall, -9, 5 ] ])
    translate(tr) holder();
}
module cap() {
  cube([ l, w, wall ], center = true);
  translate([ 0, 0, wall ])
      cube([ l - wall - wiggle_room * 2, w - wall - wiggle_room * 2, wall ],
           center = true);
}
if (part == "assembly") {
  battery();
  translate([ 0, 0, h + 5 ]) rotate([ 180, 0, 0 ]) cap();
}
if (part == "box")
  battery();
if (part == "cover")
  cap();