gm = polyshape([0 3 3 15 15 3 3 0],[6 6 9 9 0 0 3 3]); %pderect([1,2,1,2])

tr = triangulation(gm);
%plot(gm);
model = createpde(3);

tnodes = tr.Points' ;
telements = tr.ConnectivityList' ;

geometryFromMesh(model,tnodes,telements);
%pdegplot(model);
%pdegplot(model,"EdgeLabels","on");

%figure;
%pdemesh(model);
generateMesh(model); %refine the mesh

%figure;
%pdemesh(model);
msh=generateMesh(model,"Hmax",0.5,"Hedge",{[1,2,6,5],0.1});
%figure;
%pdemesh(model);

%ttgbc = @(region,state) 1+3*sin(15*state.time).^2;
Teq = 80;
Tinit = 90;
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
G1mix = [0.02;0;0];
 
specifyCoefficients(model,"m",mcoeff,"d",dcoeff,"c",ccoeff,"a",acoeff,"f",fcoeff);
applyBoundaryCondition(model,"dirichlet","Edge",[3],"h",H0,"r",R0);
applyBoundaryCondition(model,"mixed","Edge",[7],"h",H1mix,"r",R1mix,"q",Q1mix,...
     "g",G1mix);

%adiabatic boundary condition on top and bottom sides
H_adi = [0 0 0; 0 1 0; 0 0 1];
R_adi = [0;0;0];
Q_adi = [0 0 0; 0 0 0; 0 0 0];
G_adi = [0;0;0];
applyBoundaryCondition(model,"mixed","Edge",[1,2,4,5,6,8],"h",H_adi,"r",R_adi,"q",Q_adi,...
     "g",G_adi);

H14mix = [0 0 0; 0 1 0; 0 0 1];
R14mix = [0;0;0];
Q14mix = [0 0 0; 0 0 0; 0 0 0];
G14mix = [0;0;0];
%applyBoundaryCondition(model,"mixed","Edge",[1,4],"h",H14mix,"r",R14mix,"q",Q14mix,...
   % "g",G14mix);
%applyBoundaryCondition(model,"dirichlet","Edge",[2],"u",ttgbc);
% applyBoundaryCondition(model,"dirichlet","Edge",[3],"u",1);
% %applyBoundaryCondition(model,"neumann","Edge",[2],"q",0,"g",ttgbc);
% applyBoundaryCondition(model,"neumann","Edge",[1,4],"q",0,"g",0);
u0 = [Tinit;0;0] ;
setInitialConditions(model,u0);
setInitialConditions(model,[Tboundary;0;0],'edge',[3]);
%setInitialConditions(model,1,'edge',3);
endTime = 5;
tlist = 0:0.1:endTime;
result = solvepde(model,tlist);
u = result.NodalSolution;


% ux = u(:,2,end);
% uy = u(:,3,end);
%pdeplot(msh,FlowData=[ux uy]);


[X,Y]=meshgrid(0:0.01:15 , 0:0.01:9);
uinter1 = interpolateSolution(result,X,Y,1,1:length(tlist)); % 1 is number of component in u
uinter2 = interpolateSolution(result,X,Y,2,1:length(tlist));
uinter3 = interpolateSolution(result,X,Y,3,1:length(tlist));

uinter1 = squeeze(uinter1); % squeeze takes single components out of indices. 
uinter2 = squeeze(uinter2);
uinter3 = squeeze(uinter3);
uinter1 = reshape(uinter1(:,end) , size(X));
uinter2 = reshape(uinter2(:,end) , size(X));
uinter3 = reshape(uinter3(:,end) , size(X));




 figure;
 pdeplot(model,'XYData',u(:,1,end),'Contour','on','ColorMap','jet',...
     "FlowData",[u(:,2,end) , u(:,3,end)]);
 
 figure;
 pdeplot(model,'XYData',u(:,1,end),'ColorMap','jet');
 [sx,sy] = meshgrid(0:1:15 ,0:0.5:9); % initialize the streamlines
 hlines=streamline(X,Y,uinter2,uinter3,sx,sy);
 set(hlines,'LineWidth',0.3,'Color','k')
 % [sx1,sy1] = meshgrid(0.01 ,0:0.05:9);
 % hlines1 = streamline(X,Y,uinter2,uinter3,sx1,sy1);
 % [sx2,sy2] = meshgrid(3.01 ,0:0.05:3.1);
 % hlines2 = streamline(X,Y,uinter2,uinter3,sx2,sy2);
 % [sx3,sy3] = meshgrid(3.01 ,5.9:0.05:9);
 % hlines3 = streamline(X,Y,uinter2,uinter3,sx3,sy3);
 % set(hlines1,'LineWidth',0.3,'Color','k')
 % set(hlines2,'LineWidth',0.3,'Color','k')
 % set(hlines3,'LineWidth',0.3,'Color','k')
 
 figure;
 pdeplot(model,'XYData',u(:,2,end),'Contour','on','ColorMap','jet');
 
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
