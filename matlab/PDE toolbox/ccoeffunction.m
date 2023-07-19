function cmatrix = ccoeffunction(region,state,Tindex) %state is time which 
% is not needed here

% c tensor is space dependent and each component needs to be defined on
% every node.
n1 = 36; %number of c tensor componets
nr = numel(region.x);
cmatrix = zeros(n1,nr);% space dependent c tensor

% defining parameters in c tensor by using simoncelli's table
tablecoeff = readtable('CoeffDataPurified.csv');
alpha = tablecoeff.W(Tindex)*sqrt(tablecoeff.T(Tindex)*tablecoeff.A(Tindex)...
    *tablecoeff.C(Tindex));
beta = tablecoeff.W(Tindex)*sqrt(tablecoeff.A(Tindex)*tablecoeff.C(Tindex)...
    /tablecoeff.T(Tindex));
mu1111 = tablecoeff.muiiii(Tindex);
mu1212 = tablecoeff.muijij(Tindex);
mu1221 = tablecoeff.muijji(Tindex);
mu2222 = tablecoeff.muiiii(Tindex);
mu2112 = tablecoeff.muijji(Tindex);
mu2121 = tablecoeff.muijij(Tindex);
k = tablecoeff.kp(Tindex)*10^-6;

%assigning value to c tensor
cmatrix(1,:) = k; 
cmatrix(4,:) = k; 
cmatrix(6,:) = -beta*region.y ; 
cmatrix(7,:) = beta*region.y ; 
cmatrix(10,:) = beta*region.x ; 
cmatrix(11,:) = -beta*region.x ; 
cmatrix(14,:) = -alpha*region.y ; 
cmatrix(15,:) = alpha*region.y ; 
cmatrix(17,:) = mu1111 ; 
cmatrix(20,:) = mu1212 ; 
cmatrix(22,:) = 0.5*mu2112 ; 
cmatrix(23,:) = 0.5*mu2112 ; 
cmatrix(26,:) = alpha*region.x ; 
cmatrix(27,:) = -alpha*region.x ; 
cmatrix(30,:) = 0.5*mu1221 ; 
cmatrix(31,:) = 0.5*mu1221 ; 
cmatrix(33,:) = mu2121 ; 
cmatrix(36,:) = mu2222 ; 
end
