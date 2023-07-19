% Define the spatial mesh
xmesh = linspace(0,1,100);

% Define the time mesh
tspan = linspace(0,1,100);

% Solve the system of PDEs using pdepe
sol = pdepe(0,@pde_sys,@ic_sys,@bc_sys,xmesh,tspan);

% Extract the solutions for u and v
u = sol(:,:,1);
v = sol(:,:,2);

% Plot the solutions
figure;
surf(xmesh,tspan,u);
xlabel('x');
ylabel('t');
zlabel('u');
title('Solution for u(x,t)');

figure;
surf(xmesh,tspan,v);
xlabel('x');
ylabel('t');
zlabel('v');
title('Solution for v(x,t)');