pi=3.1415926;
include <../import/BOSL2/std.scad>
l=50;
d=150;
//s=120;
h=120;
w=5;

//0 - l/2 - half line
//l/2 - l/2 + r*pi - first arc
//l/2 + r*pi - 1.5*l +r*pi - straight line
//1.5*l + r*pi - 1.5*l + 2*r*pi - second arc
//1.5*l + 2*r*pi - 2*l + 2*r*pi last half

function coordinates(r,l,t)=t<l/2?[t,r]
                           :t<l/2+r*pi?[l/2,0]+[r*sin(180*(t-l/2)/(pi*r)),r*cos(180*(t-l/2)/(pi*r))]
                           :t<1.5*l +r*pi?[-(t-l-r*pi),-r]
                           :t<1.5*l+2*r*pi?[-l/2,0]+[-r*sin(180*(t-1.5*l-pi*r)/(pi*r)),-r*cos(180*(t-1.5*l-pi*r)/(pi*r))]
                           :[t-(2*l+2*r*pi),r];

function total(r,l)=2*l+2*r*pi;

function toothed_shape(r,l,d,n)=[for (i=[0:1:n-1]) each [coordinates(r,l,i*total(r,l)/n),coordinates(r-d,l,(i+0.5)*total(r-d,l)/n)]];

function params(z)=[z*0.5*d/h,(h-z)*l/h];
function ns(z)=floor(total(params(z)[0],params(z)[1])/w);

//coords=toothed_shape(20,50,2,50);
z=10;
coords=toothed_shape(params(z)[0],params(z)[1],w,ns(z));
polygon(coords);

