clear all
clc
%close all
%% -------------------------------------------------------------------------
% Pork chop plot script. Made by Sebastian Rodriguez Rosero. Oct 2022
% Based on the work David Yaylali but modified to meet our specific needs. 
% Functions  created based on algorithms from Orbital Mechanics for Engineering
% students by Curtis. UofFlorida.
    %MARS TO EARTH
 %------------------------------------------------------------------
 
%% Nominal departure and arrival times. Hour is assumed to be 0UT.
TOF=3;%months
%Departure
yearD=2022;
monthD=12;
dayD=1;
%Arrival:
yearA=yearD;
monthA=monthD+TOF;
dayA=dayD;
%Orbits for DV:
%altitute for starting orbits: 

AltitudeEARTH=1300; %km
AltitudeMARS=150;  %km

%Date to Julian. 
JD_dep = getJulian(yearD,monthD,dayD);
JD_arr = getJulian(yearA,monthA,dayA);
depDate=datetime(JD_dep,'convertfrom','juliandate','Format','dd-MMM-yyy');
depStr=cellstr(depDate);
arrDate=datetime(JD_arr,'convertfrom','juliandate','Format','dd-MMM-yyy');
arrStr=cellstr(arrDate);
fprintf('Nominal departure date: %s \n',depStr{1})
fprintf('Nominal arrival date: %s \n \n', arrStr{1})

% Define time window and grid resolution of the porkchop plot
tWindowDep = round(JD_arr-JD_dep)-1; %days past nominal departure
tWindowArr = tWindowDep; %days past nominal arrival
tStepDep = 1; % departure survey resolution
tStepArr = tStepDep; % arrival survey resolution
JDArrayDep = [ JD_dep : tStepDep : JD_dep+tWindowDep];
JDArrayArr = [ JD_arr : tStepArr : JD_arr+tWindowArr];

if JDArrayDep(end) >= JDArrayArr(1)
 fprintf('ERRROR: Some Arrival dates happen before departure, adjust the dates and time windows.')
end
 %% Get arrays for state vectors.
 %%
   rArray_dep = zeros(length(JDArrayDep),3);
   vArray_dep = zeros(length(JDArrayDep),3);
   
   rArray_arr = zeros(length(JDArrayArr),3);
   vArray_arr = zeros(length(JDArrayArr),3);
   %get state vectors. For Mars to Earth, the functions were flipped.
   %Variables referenced as Earth or Mars are thus flipped. Just didn't
   %change cause lazy. 
   for i = 1:length(JDArrayDep)
    [rArray_dep(i,:),vArray_dep(i,:)]=GetStateVectorsMARS(JDArrayDep(i));
   end
   for j = 1:length(JDArrayArr)
     [rArray_arr(j,:),vArray_arr(j,:)]=GetStateVectorsEARTH(JDArrayArr(j)) ;
   end
  

%% Get arrays for Vinfinity. 
%%    

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
        [dv_dep,dv_arr]=GetDVcircular(vInf_dep, vInf_arr, AltitudeEARTH/1e3, AltitudeMARS/1e3);
        % Compute porkchop plot values
        TOFarray(i,j) = JDf - JDi;
        vInfE(i,j) = vInf_dep;
        vInfM(i,j) = vInf_arr;
        dV_dep(i,j)=abs(dv_dep); 
        dV_arr(i,j)=abs(dv_arr);
        C3_M(i,j)=vInf_arr^2;
        C3_E(i,j)=vInf_dep^2;
        
    end
end

clear i j
fprintf('\nDONE!\n') %When the code stops calculating.

%% PLOT THE PORKCHOP

dV_cutoff=15; %km/s
dv=0.1; %step for countour set. 
% Adjust the contour lines, colors as needed.
dV_Elevels =1:dv:dV_cutoff; 
TOF_levels = 0:30:round(abs(JD_dep-(JD_arr+tWindowArr))); %[100:100:500]; %[100:100:600];
dV_Mlevels = 1:dv:dV_cutoff;
C3_levels = [10:15.5,16,17,18,20,22.5,30];
c_lim=[0 dV_cutoff];

%Colors
col1=[0.8,0.2,0.2]; %red
col2=[0.2,0.2,0.8]; %blue
col3 = [0.4,0.4,0.4]; %gray
col4=[0.392156862745098,0.831372549019608,0.0745098039215686]; %green
col5=[0.301960784313725,0.745098039215686,0.933333333333333]; %cyan

close all
figure('position',[200,200, 800, 600])
set(gcf, 'color', 'w')
tiledlayout('flow');%,'title', 'Mars-to-Earth ','FontSize',12)

% graph the contour graphs. 1
nexttile
hold on
grid on
[c2,h2]=contour(deltDepMesh, deltArrMesh, dV_dep,dV_Elevels,'linewidth',2);%, 'color', col2,'linewidth',1);
colorbar;
caxis(c_lim);
[c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
hold off

% Comment out to turn off contour labels:
% clabel(c2,h2,'Color',col2)
 clabel(c3,h3,'Color',col3)

box on
xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12)
ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12)
% title( 'Mars-to-Earth: ','FontSize',12) %v_{\infty Earth} 
legend({'\Deltav_{Mars} (km/s)','TOF (days)'},'Location','northeastoutside','fontsize',10)

% graph the contour graphs. 2

nexttile
hold on
grid on
[c1,h1]=contour(deltDepMesh, deltArrMesh, dV_arr,dV_Mlevels,'linewidth',2);%, 'color', col1,'linewidth',1);
colorbar;
caxis(c_lim);
[c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
hold off

% Comment out to turn off contour labels:
 %clabel(c1,h1,'Color',col1)
 clabel(c3,h3,'Color',col3)

box on
xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12)
ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12)
%title( 'Earth-to-Mars: v_{\infty Mars}','FontSize',12)
legend({'\Deltav_{Earth} (km/s) ','TOF (days)'},'Location','northeastoutside','fontsize',10)

% %% graph the contour graphs. 3
%{
% nexttile
% hold on
% [c2,h2]=contour(deltDepMesh, deltArrMesh, C3_E/1000^2,C3_levels);%, 'color', col4,'linewidth',1);
% colorbar;
% caxis([20 60]);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% hold off
% 
% % Comment out to turn off contour labels:
% % clabel(c2,h2,'Color',col4)
%  clabel(c3,h3,'Color',col3)
% 
% box on
% xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12)
% ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12)
% title( 'Earth-to-Mars: C_{3 Earth}','FontSize',12)
% legend({'C_{3 Earth} (km^2/s^2)','TOF (days)'},'Location','northeastoutside','fontsize',10)
% 
% %% graph the contour graphs. 4
% nexttile
% hold on
% [c2,h2]=contour(deltDepMesh, deltArrMesh, C3_M/1000^2,C3_levels);%, 'color', col5,'linewidth',1);
% colorbar;
% caxis([20 60]);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% hold off
% 
% % Comment out to turn off contour labels:
%  %clabel(c2,h2,'Color',col5)
%  clabel(c3,h3,'Color',col3)
% 
% box on
% xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12)
% ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12)
% title( 'Earth-to-Mars: C_{3 Earth}','FontSize',12)
% legend({'C_{3 Mars} (km^2/s^2)','TOF (days)'},'Location','northeastoutside','fontsize',10)
%}