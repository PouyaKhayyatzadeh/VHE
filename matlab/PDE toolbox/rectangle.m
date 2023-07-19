gm = polyshape([0 0 1 1],[0 1 1 0]); %pderect([1,2,1,2])
plot(gm);

tr = triangulation(gm); %triangulation of the geometry

model = createpde(3);

tnodes = tr.Points' ;
telements = tr.ConnectivityList' ;

geometryFromMesh(model,tnodes,telements);
pdegplot(model);

pdegplot(model,"EdgeLabels","on");

figure;
pdemesh(model);

generateMesh(model); %refine the mesh

figure;
pdemesh(model);

generateMesh(model,"Hmax",0.05,"Hedge",{[1,2,3,4],0.001});
figure;
pdemesh(model);

ttgbc = @(region,state) 1+3*sin(15*state.time).^2;

Teq = 80;
Tinit = 80;
Tboundary = 80;

tablecoeff = readtable('CoeffDataPurified.csv');
Tindex = find(tablecoeff.T==Teq);



HC = tablecoeff.C(Tindex);
A = tablecoeff.A(Tindex) ;
gamma = tablecoeff.A(Tindex)*tablecoeff.D(Tindex);
mcoeff = 0;
dcoeff = [HC;0;0;0;A;0;0;0;A] ;
ccoeff = @(region,state) ccoeffunction(region,state,Tindex);

acoeff = [0;0;0;0;gamma;0;0;0;gamma] ;
fcoeff = [0;0;0] ;

H0 = eye(3) ;
R0 = [Tboundary;0;0] ;
H1mix = [0 0 0; 0 1 0; 0 0 1];
R1mix = [0;0;0];
Q1mix = [0 0 0; 0 0 0; 0 0 0];
G1mix = [0;0;0];

 
specifyCoefficients(model,"m",mcoeff,"d",dcoeff,"c",ccoeff,"a",acoeff,"f",fcoeff);
%applyBoundaryCondition(model,"dirichlet","Edge",[1,3,4],"h",H0,"r",R0);
applyBoundaryCondition(model,"mixed","Edge",[1,2,3,4],"h",H1mix,"r",R1mix,"q",Q1mix,...
     "g",G1mix);

% H14mix = [0 0 0; 0 1 0; 0 0 1];
% R14mix = [0;0;0];
% Q14mix = [0 0 0; 0 0 0; 0 0 0];
% G14mix = [0;0;0];
%applyBoundaryCondition(model,"mixed","Edge",[1,4],"h",H14mix,"r",R14mix,"q",Q14mix,...
   % "g",G14mix);
%applyBoundaryCondition(model,"dirichlet","Edge",[2],"u",ttgbc);
% applyBoundaryCondition(model,"dirichlet","Edge",[3],"u",1);
% %applyBoundaryCondition(model,"neumann","Edge",[2],"q",0,"g",ttgbc);
% applyBoundaryCondition(model,"neumann","Edge",[1,4],"q",0,"g",0);
%u0 = @ufun ;
u0 = [Tinit;0;0];
setInitialConditions(model,u0);
%setInitialConditions(model,[1;0;0],'edge',[1,2,3,4]);
%setInitialConditions(model,1,'edge',3);
endTime = 1;
tlist = 0:0.01:endTime;
result = solvepde(model,tlist);
u = result.NodalSolution;



 figure;
 pdeplot(model,'XYData',u(:,3,end),'Contour','on','ColorMap','jet');
title(sprintf('Temperature in the Plate, Transient Solution (%d seconds)\n', ...
  tlist(1,end)));
 xlabel 'X-coordinate, meters'
 ylabel 'Y-coordinate, meters'
 axis equal;

% figure;
% %maxc = max(max(R.NodalSolution));
% %minc = min(min(R.NodalSolution));
% MyVideo = VideoWriter(sprintf('2DSys.avi'));
% MyVideo.FrameRate = 10;
% MyVideo.Quality = 100;
% open(MyVideo);
% for i = 1:200
%     pdeplot(model,'XYData',u(:,i),'ColorBar','on','Mesh','off','ColorMap','jet');
%     title({['Time=' num2str(i) 's/100']})
%     caxis([minc maxc]);
%     colormap(jet)
%     axis tight
%     ax = gca;
%     ax.DataAspectRatio = [1 1 1];
%     axis equal;
%     M(i) = getframe(gcf);
%     writeVideo(MyVideo, M);
% end
% close(MyVideo)
% 
