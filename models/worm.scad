//Swipes a body through space using polygonal trajectory. Vertices are passed as array of 3d poses.
//Project: published for np-f adapter, can be used everywhere to route cables, hoses, etc. 
module worm(path) {
  for(i=[0:len(path)-2]) {
    hull() {
      translate(path[i])children();
      translate(path[i+1])children();
    }
  }
}
worm(path=[[2.4,0,-3],[2.4,9,-3],[2.4,15,3],[2.4,0,3]])sphere(r=1.5,$fn=32);