//TPU parts to stabilize the shelf
//Project: Kauzerei Werkstatt

part="corner";//[gauge,corner]
start=8;
step=1;
end=14;
gauge_depth=5;
gauge_width=8;
width=16;
depth=26;
thickness=5;
bissl=1/100;

if (part=="gauge") {
  for(index=[0:(end-start)/step]) {
    cube([end-index*step,gauge_depth*(index+1),gauge_width]);
  }
}

if (part=="corner") {
  difference() {
    cube([width+thickness,width+depth,width]);
    translate([-bissl,-bissl,-bissl])cube([width+2*bissl,width+2*bissl,width+2*bissl]);
  }
}