
clearvars 
clear all
clc
%% -------------------------------------------------------------------------
% Pork chop plot script. Made by Sebastian Rodriguez Rosero. July 2020
% Based on the work David Yaylali but modified to meet our specific needs. 
% Functions  created based on algorithms from Orbital Mechanics for Engineering
% students by Curtis. UofFlorida.
 %------------------------------------------------------------------
 %THIS IS THE ONE. 
%% Nominal departure and arrival times. Hour is assumed to be 0UT.

%Departure
yearD=2020;
monthD=4;
dayD=1;
%Arrival:
yearA=2020;
monthA=10;
dayA=1; 

%% Date to Julian. 
JD_dep = getJulian(yearD,monthD,dayD);
JD_arr = getJulian(yearA,monthA,dayA);
depDate=datetime(JD_dep,'convertfrom','juliandate','Format','dd-MMM-yyy');
depStr=cellstr(depDate);
arrDate=datetime(JD_arr,'convertfrom','juliandate','Format','dd-MMM-yyy');
arrStr=cellstr(arrDate);
fprintf('Nominal departure date: %s \n',depStr{1})
fprintf('Nominal arrival date: %s \n \n', arrStr{1})

%% Define time window and grid resolution of the porkchop plot
tWindowDep = 180; %days past nominal departure
tWindowArr = 450; %days past nominal arrival
tStepDep =0.5; % departure survey resolution
tStepArr = 0.5; % arrival survey resolution
JDArrayDep = [ JD_dep : tStepDep : JD_dep+tWindowDep];
JDArrayArr = [ JD_arr : tStepArr : JD_arr+tWindowArr];

%% 
if JDArrayDep(end) >= JDArrayArr(1)
 fprintf('ERRROR: Some Arrival dates happen before departure, adjust the dates and time windows.')
end

 %% Get arrays for state vectors.
 %%
   rArray_dep = zeros(length(JDArrayDep),3);
   vArray_dep = zeros(length(JDArrayDep),3);
   
   rArray_arr = zeros(length(JDArrayArr),3);
   vArray_arr = zeros(length(JDArrayArr),3);
   
   for i = 1:length(JDArrayDep)
    [rArray_dep(i,:),vArray_dep(i,:)]=GetStateVectorsEARTH(JDArrayDep(i));
   end
   
   for j = 1:length(JDArrayArr)
     [rArray_arr(j,:),vArray_arr(j,:)]=GetStateVectorsMARS(JDArrayArr(j)) ;
   end
  

%% Get arrays for Vinfinity. 

for i = 1:length(JDArrayDep)

    JDi = JDArrayDep(i);

    for j = 1:length(JDArrayArr)

        JDf = JDArrayArr(j);
        
        %Build meshes for contour plot axis
        deltDepMesh(i,j) = JDi-JD_dep;
        deltArrMesh(i,j) = JDf-JD_arr;

        % Compute heliocentric orbital velocity at departure and arival
        % These are computed using Lambert's method
        TOF = 86400.0*(JDf - JDi); % time of flight, in seconds 
        [v1Vec,v2Vec]=lambert(rArray_dep(i,:),rArray_arr(j,:),TOF, 'pro');
        
        % Compute v_inf for departure and arrival
        % (i.e., subtract planet velocities)
        vInf_dep = norm(v1Vec - vArray_dep(i,:)); %km/s
        vInf_arr = norm(v2Vec - vArray_arr(j,:));%km/s

        % Compute porkchop plot values
        TOFarray(i,j) = JDf - JDi;
        vInfE(i,j) = vInf_dep;
        vInfM(i,j) = vInf_arr;
        
%         C3_M(i,j)=vInf_arr^2;
%         C3_E(i,j)=vInf_dep^2;
        
    end
end

clear i j
fprintf('\nDONE!\n') %When the code stops calculating.

%% PLOT THE PORKCHOP
%%
% Adjust the contour lines, colors as needed.

% Regular
    TOF_levels =round(linspace(100,1000,10),0);% 
%for 45
%     TOF_levels =round(linspace(20,100,12),0);% 
% 
% C3_levels = [10:15.5,16,77,18,20,22.5,30];

%Colors
col1=[0.8,0.2,0.2]; %red
col2=[0.2,0.2,0.8]; %blue
col3 = [0.4,0.4,0.4]; %gray
col4=[0.392156862745098,0.831372549019608,0.0745098039215686]; %green
col5=[0.301960784313725,0.745098039215686,0.933333333333333]; %cyan
% 
pos=[160 35 20 20]; %Location and size of rectangles. 
close all
figure(1)
set(gcf, 'color', 'w')
tiledlayout(1,2)

%% graph the contour graphs. 1
nexttile
hold on
%regular
    V_inf_Elevels=round(linspace(0,7,10),1);
    V_inf_lines=round(linspace(7,25,10),1);

% for 45
%     V_inf_Elevels=round(linspace(0,40,20),1);
%     V_inf_lines=round(linspace(40,80,15),1);

[c2,h2]=contour(deltDepMesh, deltArrMesh, vInfE/1000, V_inf_Elevels,'color', col2,'linewidth',1);
[c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
[c4,h4]=contour(deltDepMesh, deltArrMesh, vInfE/1000,V_inf_lines,'color', col2,'linewidth',1);

% grid on

hold off
%V_inf_Elevels,
% Comment out to turn off contour labels:
  clabel(c2,h2,'Color',col2)
  clabel(c3,h3,'Color',col3)
  %clabel(c4,h4,'Color',col2)
 
box on
rectangle('position',pos,'linestyle','--','linewidth',1.2)
set(gca,'FontSize',14,'FontName','Times')
xlabel(['Departure: Days past ', depStr{1},' '])
ylabel(['Arrival: Days past ', arrStr{1},' '])
title( 'Earth-to-Mars: v_{\infty Earth} ')
legend({'v_{\infty Earth} (km/s)','TOF (days)'},'Location','northwest','fontsize',14)

%,'TOF (days)'

%% graph the contour graphs. 2
%Regular
    V_inf_Mlevels=round(linspace(0,6,10),1);
    V_inf_linesM=round(linspace(6,25,7),1);
%for 45
%     V_inf_Mlevels=round(linspace(0,30,20),1);
%     V_inf_linesM=round(linspace(30,80,15),1);


nexttile
hold on
[c1,h1]=contour(deltDepMesh, deltArrMesh, vInfM/1000,V_inf_Mlevels, 'color', col1,'linewidth',1);
[c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
[c4,h4]=contour(deltDepMesh, deltArrMesh, vInfM/1000,V_inf_linesM, 'color', col1,'linewidth',1);
% grid on
hold off

% Comment out to turn off contour labels:
 clabel(c1,h1,'Color',col1)
 clabel(c3,h3,'Color',col3)
 %clabel(c4,h4,'color',col1)
 

box on
rectangle('position',pos,'linestyle','--','linewidth',1.2)
set(gca,'FontSize',14,'FontName','Times')
xlabel(['Departure: Days past ', depStr{1},' '])
ylabel(['Arrival: Days past ', arrStr{1},' '])
title( 'Earth-to-Mars: v_{\infty Mars}')
legend({'v_{\infty Mars} (km/s) ','TOF (days)'},'Location','northwest','fontsize',14)

%,'TOF (days)'
%% C3 Graphs. 
%% %% graph the contour graphs. 3
% 
% C3_levelsIE=round(linspace(0,35,15),1);
% C3_levelsFE=round(linspace(35,80,20),1);
% 
% C3_levelsIM=round(linspace(0,35,15),1);
% C3_levelsFM=round(linspace(35,80,20),1);
% 
% 
% 
% figure(2)
% tiledlayout(1,2)
% 
% nexttile
% hold on
% 
% [c2,h2]=contour(deltDepMesh, deltArrMesh, C3_E/1000^2,C3_levelsIE, 'color', col2,'linewidth',1);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% [c4,h4]=contour(deltDepMesh, deltArrMesh, C3_E/1000^2,C3_levelsFE, 'color', col2,'linewidth',1);
% % grid on
% hold off
% 
% % Comment out to turn off contour labels:
%  clabel(c2,h2,'Color',col2)
%  clabel(c3,h3,'Color',col3)
% 
% box on
% xlabel(['Departure: Days past ', depStr{1},' '],'FontSize',12,'FontName','Times')
% ylabel(['Arrival: Days past ', arrStr{1},' '],'FontSize',12,'FontName','Times')
% title( 'Earth-to-Mars: C_{3, Earth}','FontSize',12,'FontName','Times')
% legend({'C_{3, Earth} (km^2/s^2)','TOF (days)'},'Location','northwest','fontsize',10,'FontName','Times')
% 
% %% %% graph the contour graphs. 4
% nexttile
% hold on
% [c2,h2]=contour(deltDepMesh, deltArrMesh, C3_M/1000^2,C3_levelsIM, 'color', col1,'linewidth',1);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% 
% [c4,h4]=contour(deltDepMesh, deltArrMesh, C3_M/1000^2,C3_levelsFM, 'color', col1,'linewidth',1);
% 
% % grid on
% hold off
% 
% % Comment out to turn off contour labels:
%  clabel(c2,h2,'Color',col1)
%   clabel(c3,h3,'Color',col3)
% 
% box on
% xlabel(['Departure: Days past ', depStr{1},' '],'FontSize',12,'FontName','Times')
% ylabel(['Arrival: Days past ', arrStr{1},' '],'FontSize',12,'FontName','Times')
% title( 'Earth-to-Mars: C_{3, Mars}','FontSize',12,'FontName','Times')
%  legend({'C_{3, Mars} (km^2/s^2)','TOF (days)'},'Location','northwest','fontsize',10,'FontName','Times')
