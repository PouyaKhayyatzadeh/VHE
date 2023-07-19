function [pl,ql,pr,qr] = vhebc(xl,ul,xr,ur,t)
pl=1 ;%pl=[1;0] ;
ql=-1; %ql=[-1;0];
pr=80-ur; %pr=[80-ur(1);0];
qr=0; %qr=[0;0];