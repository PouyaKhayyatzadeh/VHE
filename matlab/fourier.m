m = 0;
x = linspace(0,0.1,1000); % space
t = linspace(0,1,100); % time
sol = pdepe(m,@fourierpde,@fourieric,@fourierbc,x,t);
u = sol(:,:,1);
surf(x,t,u)