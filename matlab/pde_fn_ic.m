function u0 = pde_fn_ic(x,A,B,C)
u0 = [1;1]% [1*exp(-((x)/1).^2) ; 0.2*exp(-((x+2)/1).^2)];