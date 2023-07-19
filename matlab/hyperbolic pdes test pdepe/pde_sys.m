function [c,f,s] = pde_sys(x,t,u,DuDx)
% Define the system of PDEs

c = [1; 1];
f = [-1;-1].*DuDx;
s = [0; 0];

end



