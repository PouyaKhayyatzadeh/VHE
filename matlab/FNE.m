m = 0;
x = linspace(-10,30,400); % space
t = linspace(0,400,20); % time
A=0.1; B=0.01; C=0.01;
sol = pdepe(m,@pde_fn_pde,@pde_fn_ic,@pde_fn_bc,x,t,[],A,B,C);
u1 = sol(:,:,1);
u2 = sol(:,:,2);
waterfall(x,t,u1), map=[0 0 0]; colormap(map), view(15,60)