m = 0;
x = linspace(0,1,2000); % space
t = linspace(0,1,2000); % time
%constf=1;    Tn=80;
sol = pdepe(m,@vhepde,@vheic,@vhebc,x,t);
T=sol(:,:,1);
surf(x,t,T)