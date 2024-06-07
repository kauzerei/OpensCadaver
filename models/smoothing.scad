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

//fr= [[107, -38], [101, -41], [87, -30], [71, -32], [61, -24], [47, -25], [36, -16], [25, -18], [15, -5], [0, -7]];
//ba= [[107, 5], [94, 22], [59, 44], [25, 60], [0, 60]];
fr=[[0,-55],[15,-54],[26,-52],[38,-49],[48,-45],[60,-37],[73,-27],[86,-18],[101,-6],[107,9]];
ba=[[0,11],[15,9],[25,21],[38,19],[48,30],[60,28],[73,38],[86,36],[101,47],[107,47]];
function decimate(poly,m)=len(poly)<3?poly
                         :norm(poly[0]-poly[1])<m?decimate([poly[0], for (i=[2:len(poly)-1]) poly[i]],m)
                         :[poly[0], each decimate([for (i=[1:len(poly)-1]) poly[i]],m)];
//linear_extrude(30)polygon(decimate(smooth(poly,6,loop=true),1));
$fn=64;
module skew_extrude(list,d,reverse) {
  for (i=[0:len(list)-2]) {
    startx=list[i][0];
    startz=list[i][1]+d*(reverse?-1:1)/2;
    h=list[i+1][0]-list[i][0];
    shift=list[i+1][1]-list[i][1];
    multmatrix(m=[[d,0,shift,startz],
                  [0,d,0,0],
                  [0,0,h,startx]]){cylinder(d=1,h=1);translate([reverse?-10:0,-0.5,0])cube([10,1,1]);}
  }
}
difference(){
intersection(){
skew_extrude(list=decimate(smooth(fr,6),1),d=30,reverse=false);
skew_extrude(list=decimate(smooth(ba,6),1),d=30,reverse=true);
}
hull() for (tr=[[-31,0,10],[2,0,80]]) translate(tr)
rotate([90,0,0])cylinder(d=5,h=31,center=true);
hull() for (tr=[[-31,-1.6,10],[2,-1.6,80]]) translate(tr)
rotate([90,0,0])cylinder(d=12,h=31);
hull() for (tr=[[-31,1.6,10],[2,1.6,80]]) translate(tr)
rotate([-90,0,0])cylinder(d=12,h=31);}