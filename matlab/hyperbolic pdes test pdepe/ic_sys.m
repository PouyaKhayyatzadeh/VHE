
function [u0,v0] = ic_sys(x)
% Define the initial conditions
u0 = sin(pi*x);
v0 = cos(pi*x);
end