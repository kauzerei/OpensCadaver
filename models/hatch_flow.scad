//Reimplementation of Hatch Flow pattern for OpenSCAD
//Generalized for multiple layers of depth
//Added regularity as an alternative to randomness

nhor=32; 
nvert=3;
hvert=15;
ndepth=2;
od=34;
id=22; 
bissl=0.10; //parrtern needs to be a bissl offset from slicer layers. Make it half print layer

points=[[0.5, 0.75, 1], [0.25, 1, 1], [0.75, 1, 1], [0, 1, 0.75], [0.5, 1, 0.75], [1, 1, 0.75], [0.25, 1, 0.5], [0.75, 1, 0.5], [0, 1, 0.25], [0.5, 1, 0.25], [1, 1, 0.25], [0.25, 1, 0], [0.75, 1, 0], [0, 0.75, 1], [0, 0.75, 0.5], [0, 0.75, 0], [0.5, 0.75, 0], [1, 0.75, 0], [1, 0.75, 0.5], [1, 0.75, 1], [0, 0.5, 0.75], [0, 0.5, 0.25], [0.25, 0.5, 0], [0.75, 0.5, 0], [1, 0.5, 0.25], [1, 0.5, 0.75], [0, 0.25, 1], [0, 0.25, 0.5], [0, 0.25, 0], [0.5, 0.25, 0], [1, 0.25, 0], [1, 0.25, 0.5], [1, 0.25, 1], [0, 0, 0.75], [0, 0, 0.25], [0.25, 0, 0], [0.75, 0, 0], [1, 0, 0.25], [1, 0, 0.75], [0.5, 0, 0.25], [0.25, 0, 0.5], [0.75, 0, 0.5], [0.5, 0, 0.75], [0.25, 0, 1], [0.75, 0, 1], [0.5, 0.25, 1], [0.25, 0.5, 1], [0.75, 0.5, 1]];
  faces=[[1,3,8,6,4,2],[5,7,9,11,12,10],[13,26,33,34,27,20],[3,14,21,28,15,8],[11,16,23,30,17,12],[15,28,35,36,29,22],[10,17,30,24,18,5],[19,25,31,37,38,32],[35,39,41,38,37,36],[34,33,43,44,42,40],[43,26,13,46,45,44],[32,47,0,1,2,19],[10,12,17],[33,26,43],[3,1,0,47,32,38,41,39,35,28,21,14],[2,4,6,8,15,22,29,36,37,31,25,19],[11,9,7,5,18,24,30,23,16],[13,20,27,34,40,42,44,45,46]];
  
/*
module element(as=0,ae=30,od=30,id=20,h=5,rotated=false) {
  assert(!is_undef(as));
  assert(!is_undef(ae));
  assert(!is_undef(od));
  assert(!is_undef(id));
  assert(!is_undef(h));
  assert(!is_undef(rotated));
  mp=(od+id)/4;
  q=(od-id)/8;
  p1=[[-1,-2,-2],[1,-2,-2],[2,-1,-2],[2,1,-2], //z=-2
     [-2,1,2],[-2,-1,2],[-2,-2,1],[-2,-2,-1], //x=-2
     [1,2,2],[-1,2,2],[2,2,-1],[2,2,1]];//y=2
  p2=[[1,-2,2],[2,-2,1],[2,-1,2],[-1,-2,2],[2,-2,-1],[2,1,2]];
  p3=[[-1,2,-2],[-2,2,-1],[-2,1,-2],[1,2,-2],[-2,2,1],[-2,-1,-2]];
  function rot(pts)= [for (p=pts) [p[2],p[1],-p[0]]];
  function bend(pts,mp,q,as,ae) =[for (p=pts) [(mp+q*p[0])*cos(as*(0.5-p[1]/4)+ae*(0.5+p[1]/4)),(mp+q*p[0])*sin(as*(0.5-p[1]/4)+ae*(0.5+p[1]/4)),h*p[2]/4]];
  polyhedron(points=bend(rotated?rot(p1):p1,mp,q,as,ae),
              faces=[[0,1,2,3], [9,8,5,4], //same z
                     [4,5,6,7], [11,10,3,2], //same x
                     [8,9,10,11], [7,6,1,0], //same y
                     [0,3,10,9,4,7], [2,1,6,5,8,11]]);
  polyhedron(points=bend(rotated?rot(p2):p2,mp,q,as,ae),
              faces=[[0,2,1],[3,4,5],[0,3,5,2],[0,1,4,3],[1,2,5,4]]);
  polyhedron(points=bend(rotated?rot(p3):p3,mp,q,as,ae),
              faces=[[0,1,2],[3,5,4],[2,5,3,0],[3,4,1,0],[4,5,2,1]]);
} 
*/
/*
module ring(nhor=16,nvert=3,hvert=6,ndepth=1,od=60,id=50) {
  randoms=rands(0,2,nhor*nvert*ndepth);
  //rotations=[for (r=randoms) r>1]; 
  rotations=[for (i=[0:1:nhor*nvert*ndepth]) i%2==0 ];
  //rotations=[for (i=[0:1:nhor*nvert*ndepth-1]) i%3==0 ];
  //rotations=[for (i=[0:1:nhor*nvert*ndepth-1]) i%5>2 ];
  echo(rotations);
  p=[for (k=[0:ndepth-1]) for (j=[0:nvert-1)]) for (i=[0:nhor-1])
          xmin=
          [j,i,i+360/nhor,k+(od-id)/ndepth,k,hvert/nvert]];
  for (i=[0:1:nhor*nvert*ndepth-1])
    translate([0,0,p[i][0]]) element(p[i][1],p[i][2],p[i][3],p[i][4],p[i][5],rotations[i]);
  translate([0,0,-hvert/(2*nvert)])cylinder(h=hvert,d=id+0.1,$fn=nhor*4);
}
*/
module test_tile(nhor=16,nvert=3,hvert=6,ndepth=1,od=60,id=50) {
  randoms=rands(0,2,nhor*nvert*ndepth);
  //rotations=[for (r=randoms) r>1]; 
  //rotations=[for (i=[0:1:nhor*nvert*ndepth]) i%2==0 ];
  //rotations=[for (i=[0:1:nhor*nvert*ndepth-1]) i%3==0 ];
  //rotations=[for (i=[0:1:nhor*nvert*ndepth-1]) i%5>2 ];
  //rotations=[false,false,false,false,false,false,false,false];
  rotations=[false,true,false,true,true,false,true,false];
  //echo(rotations);
  p=[for (k=[id,id+(od-id)/ndepth])
      for (j=[0,hvert/nvert])
        for (i=[0,360/nhor])
          [j,i,i+360/nhor,k+(od-id)/ndepth,k,hvert/nvert]];
  for (i=[0:1:7])
    translate([0,0,p[i][0]]) element(p[i][1],p[i][2],p[i][3],p[i][4],p[i][5],rotations[i]);
  translate([0,0,-hvert/(2*nvert)])cylinder(h=hvert,d=id+0.1,$fn=nhor*4);
}

//ring(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=ndepth,od=od,id=id);
//test_tile(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=ndepth,od=od,id=id);
//element();

/* Following code is not used in the model, but was used during development. But can still be useful for understanding, since it does not have polyhedron() calls with low-level vertex manipulations. unit() generates basically same building block as element(), just not bent, therefore consisting only of three intersections of cuboid pairs. pattern() builds small wall out of those blocks to see how they can be stacked.
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
module unit(xmin=0,xmax=10,ymin=0,ymax=10,zmin=0,zmax=10) {

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
  points=[[0.5, 0.75, 1], [0.25, 1, 1], [0.75, 1, 1], [0, 1, 0.75], [0.5, 1, 0.75], [1, 1, 0.75], [0.25, 1, 0.5], [0.75, 1, 0.5], [0, 1, 0.25], [0.5, 1, 0.25], [1, 1, 0.25], [0.25, 1, 0], [0.75, 1, 0], [0, 0.75, 1], [0, 0.75, 0.5], [0, 0.75, 0], [0.5, 0.75, 0], [1, 0.75, 0], [1, 0.75, 0.5], [1, 0.75, 1], [0, 0.5, 0.75], [0, 0.5, 0.25], [0.25, 0.5, 0], [0.75, 0.5, 0], [1, 0.5, 0.25], [1, 0.5, 0.75], [0, 0.25, 1], [0, 0.25, 0.5], [0, 0.25, 0], [0.5, 0.25, 0], [1, 0.25, 0], [1, 0.25, 0.5], [1, 0.25, 1], [0, 0, 0.75], [0, 0, 0.25], [0.25, 0, 0], [0.75, 0, 0], [1, 0, 0.25], [1, 0, 0.75], [0.5, 0, 0.25], [0.25, 0, 0.5], [0.75, 0, 0.5], [0.5, 0, 0.75], [0.25, 0, 1], [0.75, 0, 1], [0.5, 0.25, 1], [0.25, 0.5, 1], [0.75, 0.5, 1]];
  /*The faces list is produced by hand by looking at the before mentioned drawing of a net of a cube. Extra collinear vertices are here on purpose, without them OpenSCAD sometimes fails to recognize coplanarity of neighboring faces and produces incorrect geometry, namely extra walls inside the boda, which breaks hatch flow on slicing*/
  faces=[[1,3,8,6,4,2],[5,7,9,11,12,10],[13,26,33,34,27,20],[3,14,21,28,15,8],[11,16,23,30,17,12],[15,28,35,36,29,22],[10,17,30,24,18,5],[19,25,31,37,38,32],[35,39,41,38,37,36],[34,33,43,44,42,40],[43,26,13,46,45,44],[32,47,0,1,2,19],[10,12,17],[33,26,43],[3,1,0,47,32,38,41,39,35,28,21,14],[2,4,6,8,15,22,29,36,37,31,25,19],[11,9,7,5,18,24,30,23,16],[13,20,27,34,40,42,44,45,46]];
  polyhedron(points=points,faces=faces);
}
module element(amin=0,amax=12,rmin=20,rmax=25,zmin=0,zmax=5,flipped=false) {
  assert(!is_undef(amin));
  assert(!is_undef(amax));
  assert(!is_undef(rmin));
  assert(!is_undef(rmax));
  assert(!is_undef(zmin));
  assert(!is_undef(zmax));
  assert(!is_undef(flipped));
  
  function flip(points)=[for (p=points) [1-p[0],1-p[1],p[2]]];
  function map_cylinder(amin,amax,rmin,rmax,zmin,zmax,points)=[for (p=points) [(rmin+p[0]*(rmax-rmin))*cos(amin+p[1]*(amax-amin)),(rmin+p[0]*(rmax-rmin))*sin(amin+p[1]*(amax-amin)),zmin+p[2]*(zmax-zmin)]];
  polyhedron(points=map_cylinder(amin,amax,rmin,rmax,zmin,zmax,flipped?flip(points):points),faces=faces);
}
//element();
//element(amin=348,amax=360,flipped=true);
module ring(nhor=16,nvert=3,hvert=10,ndepth=1,od=15,id=10) {
  function angle(i)=i*360/nhor;
  function radius(i)=id/2+i*0.5*(od-id)/ndepth;
  function zvalue(i)=i*hvert/nvert;  
  randoms=rands(0,2,nhor*nvert*ndepth);

  //calculating vector of orientations of elements (true if flipped)
  //flipped=[for (r=randoms) r>1]; 
  flipped=[for (i=[0:1:nhor*nvert*ndepth]) i%2==0 ];
  //flipped=[for (i=[0:1:nhor*nvert*ndepth-1]) i%3==0 ];
  //flipped=[for (i=[0:1:nhor*nvert*ndepth-1]) i%5>2 ];
  //echo(flipped);
  
  //calculating vector of parameters of element() module
  p=[for (k=[0:ndepth-1]) for (j=[0:nvert-1]) for (i=[0:nhor-1])
    [angle(i),angle(i+1),radius(k),radius(k+1),zvalue(j),zvalue(j+1)]];
  
  for (i=[0:1:nhor*nvert*ndepth-1]) element(p[i][0],p[i][1],p[i][2],p[i][3],p[i][4],p[i][5],flipped[i]);
  translate([0,0,-bissl])cylinder(h=hvert+bissl,d=id+0.1,$fn=nhor*4);
}
translate([0,0,bissl])ring(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=ndepth,od=od,id=id);