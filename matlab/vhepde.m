function [c,f,s] = vhepde(x,t,u,dudx)
c=1 ; %c = [1 ; 1];
f=-1 ; %f = [-1 ; -1] .*dudx ;
%rhsT =0; %dudx(2);
%rhsU = 0; % dudx(1) - u(2);
s=0; %s= [0;0];