//Reimplementation of Hatch Flow pattern for OpenSCAD
//Generalized for multiple layers of depth
//Added regularity as an alternative to randomness

nhor=32;
nvert=3;
hvert=15;
ndepth=2;
od=34;
id=22; 

module element(as,ae,od,id,h,rotated=false) {
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

module ring(nhor=16,nvert=3,hvert=6,ndepth=1,od=60,id=50) {
  randoms=rands(0,2,nhor*nvert*ndepth);
  //rotations=[for (r=randoms) r>1]; 
  rotations=[for (i=[0:1:nhor*nvert*ndepth]) i%2==0 ];
  //rotations=[for (i=[0:1:nhor*nvert*ndepth-1]) i%3==0 ];
  //rotations=[for (i=[0:1:nhor*nvert*ndepth-1]) i%5>2 ];
  echo(rotations);
  p=[for (k=[id:(od-id)/ndepth:od-(od-id)/ndepth])
      for (j=[0:hvert/nvert:hvert*(1-1/nvert)])
        for (i=[0:360/nhor:360-360/nhor])
          [j,i,i+360/nhor,k+(od-id)/ndepth,k,hvert/nvert]];
  for (i=[0:1:nhor*nvert*ndepth-1])
    translate([0,0,p[i][0]]) element(p[i][1],p[i][2],p[i][3],p[i][4],p[i][5],rotations[i]);
  translate([0,0,-hvert/(2*nvert)])cylinder(h=hvert,d=id+0.1,$fn=nhor*4);
}

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

ring(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=ndepth,od=od,id=id);
//test_tile(nhor=nhor,nvert=nvert,hvert=hvert,ndepth=ndepth,od=od,id=id);


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