//Reimplementation of Hatch Flow pattern for OpenSCAD
//Generalized for multiple layers of depth
//Added regular patterns as an alternative to randomness
//Needs to be printed in surface mode with spiralized contour, so the slicer ignores the central solid part
//Otherwise it makes no sence, the whole gimmick is printing as continious extrusion
//Works with Manifold, at least on Linux
//If Cura doesn't want to produce continious line and generates jumps, adding horizontal expansion 0.001 helps

//horizontal density of pattern, nubmer of line pairs on one cylinder circumference
nhor=32; 

//vertical density of pattern, nubmer of line pairs from top to bottom
nvert=3;

//radial density of pattern, nubmer of line pairs on one cylinder radius
ndepth=2;

//pattern type
pattern="X out of Y";//[X out of Y,random,user_defined]
user_defined_pattern=[for (i=[0:1:nhor*nvert*ndepth-1]) i%7%5==0?0:1 ];
X=3;
Y=5;

//cylinder height
hvert=15;

//cylinder outer diameter
od=34;

//cylinder inner diameter
id=22; 

//calculating vector of orientations of elements (true if flipped)
randoms=rands(0,3.999,nhor*nvert*ndepth);
//flipped=(pattern=="random")?[for (r=randoms) floor(r)]: //initially tried all 4 possible orientations
flipped=(pattern=="random")?[for (r=randoms) r<2?0:1]:
    (pattern=="X out of Y")?[for (i=[0:1:nhor*nvert*ndepth-1]) i%Y<X?1:0 ]:
                            user_defined_pattern;
echo(flipped); //way to store pattern if you liked it

points=[[0.5, 0.75, 1.0], [0.25, 1.0, 1.0], [0.75, 1.0, 1.0], [0.0, 1.0, 0.75], [0.5, 1.0, 0.75], [1.0, 1.0, 0.75], [0.25, 1.0, 0.5], [0.75, 1.0, 0.5], [0.0, 1.0, 0.25], [0.5, 1.0, 0.25], [1.0, 1.0, 0.25], [0.25, 1.0, 0], [0.75, 1.0, 0], [0.0, 0.75, 1.0], [0.0, 0.75, 0.5], [0.0, 0.75, 0.0], [0.5, 0.75, 0.0], [1.0, 0.75, 0.0], [1.0, 0.75, 0.5], [1.0, 0.75, 1.0], [0.0, 0.5, 0.75], [0.0, 0.5, 0.25], [0.25, 0.5, 0.0], [0.75, 0.5, 0.0], [1.0, 0.5, 0.25], [1.0, 0.5, 0.75], [0.0, 0.25, 1.0], [0.0, 0.25, 0.5], [0.0, 0.25, 0.0], [0.5, 0.25, 0.0], [1.0, 0.25, 0.0], [1.0, 0.25, 0.5], [1.0, 0.25, 1.0], [0.0, 0.0, 0.75], [0.0, 0.0, 0.25], [0.25, 0.0, 0.0], [0.75, 0.0, 0.0], [1.0, 0.0, 0.25], [1.0, 0.0, 0.75], [0.5, 0.0, 0.25], [0.25, 0.0, 0.5], [0.75, 0.0, 0.5], [0.5, 0.0, 0.75], [0.25, 0.0, 1.0], [0.75, 0.0, 1.0], [0.5, 0.25, 1.0], [0.25, 0.5, 1.0], [0.75, 0.5, 1.0]];
//all 4 possible orientations of pattern element
vertices=[points, //corner in 0,0,1
         [for (p=points) [1-p[0],1-p[1],p[2]]], //corner in 0,0,0
         [for (p=points) [1-p[0],p[1],1-p[2]]], //corner in 1,0,0
         [for (p=points) [p[0],1-p[1],1-p[2]]]];//corner in 0,1,0
         
faces=[[3, 8, 6], [4, 2, 1], [3, 6, 1], [4, 1, 6],[9, 11, 12], [10, 5, 7], [9, 12, 7], [10, 7, 12],[33, 34, 27], [20, 13, 26], [33, 27, 26], [20, 26, 27],[21, 28, 15], [8, 3, 14], [21, 15, 14], [8, 14, 15],[23, 30, 17], [12, 11, 16], [23, 17, 16], [12, 16, 17],[35, 36, 29], [22, 15, 28], [35, 29, 28], [22, 28, 29],[17, 30, 24], [18, 5, 10], [17, 24, 18], [18, 10, 17],[31, 37, 38], [32, 19, 25], [31, 38, 32], [32, 25, 31],[43, 44, 42], [40, 34, 33], [43, 42, 40], [43, 40,33], [41, 38, 37], [36, 35, 39], [41, 37, 36], [39,41,36],[26, 13, 46], [45, 44, 43], [26, 46, 45], [45, 43, 26],[0, 1, 2], [19, 32, 47], [0, 19, 47], [19, 0, 2],[10,12,17],[33,26,43],[3,1,0],[3,0,14],[14,0,47],[14,47,39],[14,39,21],[21,39,35],[21,35,28],[39,47,41],[41,47,32],[41,32,38],[6,8,15],[6,15,22],[6,22,4],[29,36,37],[29,37,31],[29,31,22],[19,2,25],[2,4,25],[25,4,31],[4,22,31],[7,5,18],[18,9,7],[23,9,18],[24,23,18],[24,30,23],[16,11,9],[23,16,9],[27,34,40],[27,40,20],[20,40,45],[40,42,45],[42,44,45],[13,20,46],[46,20,45]];

/* Following code is not used in the model, only during development. But can still be useful for understanding, since it does not have polyhedron() calls with low-level vertex manipulations. unit() generates basically same building block as element(), just not bent, therefore consisting only of three intersections of cuboid pairs. pattern() builds small wall out of those blocks to see how they can be stacked.
x=2.0;
appr=5;
y=x*sqrt(12);

module unit(x=5,y=5*sqrt(12)) { //for generating straight non-cylindrical patterns. Used during developnment
  intersection(){
    rotate([atan(sqrt(2)),0,45])cube([appr*x,appr*x,x],center=true);
    cube([y,y,y],center=true);
  }
  intersection(){
    rotate([atan(sqrt(2)),0,45])translate([0,0,2*x])cube([appr*x,appr*x,x],center=true);
    cube([y,y,y],center=true);
  }
  intersection(){
    rotate([atan(sqrt(2)),0,45])translate([0,0,-2*x])cube([appr*x,appr*x,x],center=true);
    cube([y,y,y],center=true);
  }
}
module pattern() { // straight non-cylindrical wall with this pattern. Used during development
  t=[for (i=[1:4]) for (j=[1:4]) [0,i*y,j*y]];
  for (trans=t) translate(trans) rotate([0,rands(0,2,1)[0]>1?90:0,0]) unit(x,y);  
}
pattern();
*/

module unit(xmin=0,xmax=10,ymin=0,ymax=10,zmin=0,zmax=10) { //also not used in ring

  /* initially I produced the list of points by drawing a net of cube on paper, indexing vertices of future faces with numbers 0 through 48, making lists of points that have certain x, y and z values and then populating the list with isin() function, this way is less prone to human error. However, depending on OpenSCAD version this function may produce warnings, so now the list of points is initialized directly, using echo() output of initial method 
  function isin(list,value)=len(search(value,list))>0;
  listx0=[3,8,13,14,15,20,21,26,27,28,33,34];
  listx025=[1,6,11,22,35,40,43,46];
  listx05=[4,9,16,29,39,42,45,0];
  listx075=[2,7,12,23,36,41,44,47];
  listy0=[35,36,34,39,37,40,41,33,42,38,43,44];
  listy025=[26,27,28,29,30,31,32,45];
  listy05=[20,21,22,23,24,25,46,47];
  listy075=[13,14,15,16,17,18,19,0];
  listz0=[11,12,15,16,17,22,23,28,29,30,35,36];
  listz025=[8,9,10,24,37,39,34,21];
  listz05=[6,7,18,31,41,40,27,14];
  listz075=[3,4,5,25,38,42,33,20,];

  points=[for (i=[0:47]) [isin(listx0,i)?0:isin(listx025,i)?0.25:isin(listx05,i)?0.5:isin(listx075,i)?0.75:1,
                          isin(listy0,i)?0:isin(listy025,i)?0.25:isin(listy05,i)?0.5:isin(listy075,i)?0.75:1,
                          isin(listz0,i)?0:isin(listz025,i)?0.25:isin(listz05,i)?0.5:isin(listz075,i)?0.75:1]];
  echo(points);
  */

  /*The faces list is produced by hand by looking at the before mentioned drawing of a net of a cube. Extra collinear vertices are here on purpose, without them OpenSCAD sometimes fails to recognize coplanarity of neighboring faces and produces incorrect geometry, namely extra walls inside the boda, which breaks hatch flow on slicing*/
faces=[[1,3,8,6,4,2],[5,7,9,11,12,10],[13,26,33,34,27,20],[3,14,21,28,15,8],[11,16,23,30,17,12],[15,28,35,36,29,22],[10,17,30,24,18,5],[19,25,31,37,38,32],[35,39,41,38,37,36],[34,33,43,44,42,40],[43,26,13,46,45,44],[32,47,0,1,2,19],[10,12,17],[33,26,43],[3,1,0,47,32,38,41,39,35,28,21,14],[2,4,6,8,15,22,29,36,37,31,25,19],[11,9,7,5,18,24,30,23,16],[13,20,27,34,40,42,44,45,46]]; //original non-planar faces, were later divided into triangles
  polyhedron(points=points,faces=faces);
}

module element(amin=0,amax=12,rmin=20,rmax=25,zmin=0,zmax=5,flipped=0) {
  assert(!is_undef(amin));
  assert(!is_undef(amax));
  assert(!is_undef(rmin));
  assert(!is_undef(rmax));
  assert(!is_undef(zmin));
  assert(!is_undef(zmax));
  assert(!is_undef(flipped));
  
//  function flip(points)=[for (p=points) [1-p[0],1-p[1],p[2]]];
  function map_cylinder(amin,amax,rmin,rmax,zmin,zmax,points)=[for (p=points) [(rmin*(1-p[0])+p[0]*rmax)*cos(amin*(1-p[1])+p[1]*amax),(rmin*(1-p[0])+p[0]*rmax)*sin(amin*(1-p[1])+p[1]*amax),zmin*(1-p[2])+p[2]*zmax]];
  polyhedron(points=map_cylinder(amin,amax,rmin,rmax,zmin,zmax,vertices[flipped]),faces=faces);
}

module ring(nhor=16,nvert=3,hvert=10,ndepth=1,od=15,id=10,flipped=[ for (f=[1:nhor*nvert*hvert]) f%5<3?0:1]) {
  function angle(i)=i*360/nhor;
  function radius(i)=id*0.5+i*0.5*(od-id)/ndepth;
  function zvalue(i)=i*hvert/nvert;  
  
  //calculating vector of parameters of element() module
  p=[for (k=[0:ndepth-1]) for (j=[0:nvert-1]) for (i=[0:nhor-1])
    [angle(i),angle(i+1),radius(k),radius(k+1),zvalue(j),zvalue(j+1)]];
  
  for (i=[0:1:nhor*nvert*ndepth-1]) element(p[i][0],p[i][1],p[i][2],p[i][3],p[i][4],p[i][5],flipped[i]);
}
ring(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=ndepth,od=od,id=id,flipped=flipped);
cylinder(h=hvert,d=id,$fn=nhor*4);

//for (i=[0:0]) translate([1.1*i,0,0]) polyhedron(points=vertices[i%2],faces=faces); //four elements for debugging
//polyhedron(points=vertices[0],faces=faces); //one element for debugging