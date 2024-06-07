//https://kitwallace.tumblr.com/post/84772141699/smooth-knots-from-coordinates
//https://tu-dresden.de/bu/umwelt/hydro/iak/ressourcen/dateien/systemanalyse/studium/folder-2009-01-29-lehre/systemanalyse/LBE/wws-en-03.pdf?lang=en
// ==================================================================
// Interpolation and path smoothing

// Takes a path of points (any dimensionality),
// and inserts additional points between the points to smooth it.
// Repeats that n times, and returns the result.
// If loop is true, connects the end of the path to the beginning.
function smooth(path, n=4, loop=false) =
  n == 0
    ? path
    : loop
      ? smooth(subdivide_loop(path), n-1, true)
      : smooth(subdivide(path), n-1, false);

// Takes an open-ended path of points (any dimensionality), 
// and subdivides the interval between each pair of points from i to the end.
// Returns the new path.
function subdivide(path) =
  let(n = len(path))
  flatten(concat([for (i = [0 : 1 : n-1])
    i < n-1? 
      // Emit the current point and the one halfway between current and next.
      [path[i], interpolateOpen(path, n, i)]
    :
      // We're at the end, so just emit the last point.
      [path[i]]
  ]));

// Takes a closed loop points (any dimensionality), 
// and subdivides the interval between each pair of points from i to the end.
// Returns the new path.
function subdivide_loop(path, i=0) = 
  let(n = len(path))
  flatten(concat([for (i = [0 : 1 : n-1])
    [path[i], interpolateClosed(path, n, i)]
  ]));

weight = [-1, 9, 9, -1] / 16;
weight0 = [3, 6, -1] / 8;
weight2 = [1, 1] / 2;

// Interpolate on an open-ended path, with discontinuity at start and end.
// Returns a point between points i and i+1, weighted.
function interpolateOpen(path, n, i) =
  i == 0? 
    n == 2?
      path[i]     * weight2[0] +
      path[i + 1] * weight2[1]
    :
      path[i]     * weight0[0] +
      path[i + 1] * weight0[1] +
      path[i + 2] * weight0[2]
  : i < n - 2?
    path[i - 1] * weight[0] +
    path[i]     * weight[1] +
    path[i + 1] * weight[2] +
    path[i + 2] * weight[3]
  : i < n - 1?
    path[i - 1] * weight0[2] +
    path[i]     * weight0[1] +
    path[i + 1] * weight0[0]
  : 
    path[i];

// Use this to interpolate for a closed loop.
function interpolateClosed(path, n, i) =
  path[(i + n - 1) % n] * weight[0] +
  path[i]               * weight[1] +
  path[(i + 1) % n]     * weight[2] +
  path[(i + 2) % n]     * weight[3] ;

// ==================================================================
// Modeling a noodle: extrusion tools.
// Mostly from Kris Wallace's knot_functions, modified to remove globals
// and to allow for non-looped paths.

// Given a three-dimensional array of points (or a list of lists of points),
// return a single-dimensional vector with all the data.
function flatten(list) = [ for (i = list, v = i) v ]; 

//path=[[39, 147], [41, 141], [44, 132], [41, 125], [37, 119], [39, 114], [41, 108], [39, 101], [36, 95], [38, 91], [41, 84], [40, 77], [37, 70], [40, 65], [43, 57], [40, 48], [39, 40], [42, 35], [51, 35], [76, 44], [92, 56], [101, 88], [106, 121], [108, 145], [103, 152], [70, 156]];
path=[[39,148],[44,131],[37,119],[40,106],[35,94],[40,81],[37,70],[43,56],[39,36],[91,56],[105,149]];
//polygon(path);
difference(){
linear_extrude(14.92) polygon(smooth(path, loop=true,n=3));
minkowski(){
linear_extrude(1/1000) difference(){offset(delta=1/1000)polygon(smooth(path, loop=true,n=3));polygon(smooth(path, loop=true,n=3));}
rotate_extrude(angle=360)difference(){square(15);translate([15,0])circle(15);}
}
hull() for(tr=[[75,70,-1/100],[80,130,-1/100]])translate(tr) cylinder(d=5,h=16);
hull() for(tr=[[75,70,3],[80,130,3]])translate(tr) cylinder(d=10,h=16);
}