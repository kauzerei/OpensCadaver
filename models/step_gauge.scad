start=8;
step=1;
end=14;
depth=5;
width=8;

for(index=[0:(end-start)/step]) {
  cube([end-index*step,depth*(index+1),width]);
}