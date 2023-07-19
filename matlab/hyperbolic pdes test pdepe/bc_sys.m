function [pl,ql,pr,qr] = bc_sys(xl,ul,xr,ur,t)
% Define the boundary conditions
pl = [ul(1); ul(2)]; % u(xl,t), v(xl,t)
ql = [0; 0]; % Dirichlet boundary conditions at x=0
pr = [ur(1); ur(2)]; % u(xr,t), v(xr,t)
qr = [0; 0]; % Dirichlet boundary conditions at x=1
end
