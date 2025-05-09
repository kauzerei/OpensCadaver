pi=3.1415926;
/*include <../import/BOSL2/std.scad>
function toothed_pill(r1,r2,l,nr,nl)=[

];
module toothed_pill(r1,r2,l,nr,nl) {
//nr=1,3,5,...
//nl=1,3,5,...
s1=[for (i=[0:1:(nl+1)/2]) each [[l/(2*nl)+i*nl,r1],[x,]]];
arc1=[];
s2=[];
arc2=[];
s3=[];

//s1=[l/(2*nl):l/nl:l/2];
}

toothed_pill(10,20,50,21,21);
*/
function coordinates(r,l,t)=t<l/2?[t,r]
                           :t<l/2+r*pi?[l/2,0]+[r*sin(180*(t-l/2)/(pi*r)),r*cos(180*(t-l/2)/(pi*r))]
                           :t<1.5*l +r*pi?[-(t-l-r*pi),-r]
                           :t<1.5*l+2*r*pi?[-l/2,0]+[-r*sin(180*(t-1.5*l-pi*r)/(pi*r)),-r*cos(180*(t-1.5*l-pi*r)/(pi*r))]
                           :[t-(2*l+2*r*pi),r];

function total(r,l)=2*l+2*r*pi;
function toothed_shape(r,l,d,n)=[for (i=[0:1:n-1]) each [coordinates(r,l,i*total(r,l)/n),coordinates(r-d,l,(i+0.5)*total(r-d,l)/n)]];
//coords=[for (t=[0:1:total(10,50)]) coordinates (10,50,t) ];
coords=toothed_shape(20,50,2,50);
polygon(coords);
//0 - l/2 - half line
//l/2 - l/2 + r*pi - first arc
//l/2 + r*pi - 1.5*l +r*pi - straight line
//1.5*l + r*pi - 1.5*l + 2*r*pi - second arc
//1.5*l + 2*r*pi - 2*l + 2*r*pi last half
//