clear all
clc
%% -------------------------------------------------------------------------
% Pork chop plot script. Made by Sebastian Rodriguez Rosero. July 2020
% Based on the work of David Yaylali but modified to meet our specific needs. 
% Functions  created based on algorithms from Orbital Mechanics for Engineering
% students by Curtis. UofFlorida.

%updated on: 7/31/2020.
 %------------------------------------------------------------------
 
%% Nominal departure and arrival times. Hour is assumed to be 0 UT.
%Initial parameters. Enter below the nominal dates. that is, the original
%dates for travel. 

% %Departure
yearD=2022;
monthD=6;
dayD=1;
% %Arrival:
yearA=2022;
monthA=12;
dayA=31;

[date1,date2]=choosedates();
%Date to Julian. 

JD_dep = getJulian(date1);
JD_arr = getJulian(date2);

depDate=datetime(JD_dep,'convertfrom','juliandate','Format','dd-MMM-yyy');
depStr=cellstr(depDate);
arrDate=datetime(JD_arr,'convertfrom','juliandate','Format','dd-MMM-yyy');
arrStr=cellstr(arrDate);
fprintf('Nominal departure date: %s \n',depStr{1})
fprintf('Nominal arrival date: %s \n \n', arrStr{1})

%This section helps define the window of days after the nominal date to be
%evaluated. Additionally, it contains the step size. Smaller step sizes
%mean higher accuracy but increased calculation time. 

% Define time window and grid resolution of the porkchop plot
tWindowDep = 160; %days past nominal departure
tWindowArr = 350; %days past nominal arrival
tStepDep = 1; % departure survey resolution
tStepArr = 1; % arrival survey resolution
JDArrayDep = [JD_dep : tStepDep : JD_dep+tWindowDep];
JDArrayArr = [JD_arr : tStepArr : JD_arr+tWindowArr];

%Fail safe to make sure all the dates are actually calculated. 
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
    [rArray_dep(i,:),vArray_dep(i,:)]=GetStateVectors(JDArrayDep(i),planetdatadeparture);
   end
   for j = 1:length(JDArrayArr)
     [rArray_arr(j,:),vArray_arr(j,:)]=GetStateVectors(JDArrayArr(j),planetdataarrival) ;
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
        C3_M(i,j)=vInf_arr^2;
        C3_E(i,j)=vInf_dep^2;
        
    end
end

clear i j
fprintf('\nDONE!\n') %When the code stops calculating.

%% PLOT THE PORKCHOP
%% You can plot as many of these as needed, just comment out the ones not to be used. 
% Adjust the contour lines, colors as needed.
V_inf_Elevels =[1.5,1.8,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0,3.5,4.0,5.0,6.0,7.0,8.0,9:20];% [10:50]; 
TOF_levels =[100:100:500]; %[100:100:600];  [5:5:60]; %
V_inf_Mlevels = [1.5,1.8,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0,3.5,4.0,5.0,6.0,7.0,8.0,9:20];%[10:50];%
C3_levels = [10:15.5,16,17,18,20,22.5,30];

%Colors
col1=[0.8,0.2,0.2]; %red
col2=[0.2,0.2,0.8]; %blue
col3 = [0.4,0.4,0.4]; %gray
col4=[0.392156862745098,0.831372549019608,0.0745098039215686]; %green
col5=[0.301960784313725,0.745098039215686,0.933333333333333]; %cyan

close all
figure('position',[200,200, 800, 600])
set(gcf, 'color', 'w')
% tiledlayout(2,2)

%% graph the contour graphs. V infinity at Earth departure
% nexttile
% figure(1)
% hold on
% grid on
% [c2,h2]=contour(deltDepMesh, deltArrMesh, vInfE/1000,V_inf_Elevels,'linewidth',1);%, 'color', col2,'linewidth',1);
% colorbar;
% caxis([min(V_inf_Elevels) max(V_inf_Elevels)]);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% hold off
% 
% % Comment out to turn off contour labels:
% % clabel(c2,h2,'Color',col2)
% clabel(c3,h3,'Color',col3)
% grid on
% grid minor
% box on
% xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12,'FontName','Times')
% ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12,'FontName','Times')
% % title( 'Earth-to-Mars: ','FontSize',12) %v_{\infty Earth} 
% legend({'v_{\infty Earth} (km/s)','TOF (days)'},'Location','northeast','fontsize',10)

%% graph the contour graphs. 2 V infinity at Mars arrival
figure(2)

% nexttile
hold on
grid on
[c1,h1]=contour(deltDepMesh, deltArrMesh, vInfM/1000,V_inf_Mlevels,'linewidth',1);%, 'color', col1,'linewidth',1);
colorbar;
caxis([min(V_inf_Mlevels) max(V_inf_Mlevels)]);
[c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
hold off

% Comment out to turn off contour labels:
 %clabel(c1,h1,'Color',col1)
 clabel(c3,h3,'Color',col3)
grid on
grid minor
box on
xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12,'FontName','Times')
ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12,'FontName','Times')
%title( 'Earth-to-Mars: v_{\infty Mars}','FontSize',12)
legend({'v_{\infty Mars} (km/s) ','TOF (days)'},'Location','northeast','fontsize',10)

%% %% graph the contour graphs. 3 C3 for Earth departure.
% nexttile
% figure(3)
% hold on
% [c2,h2]=contour(deltDepMesh, deltArrMesh, C3_E/1000^2,C3_levels,'linewidth',1);
% colorbar;
% caxis([min(C3_levels) max(C3_levels)]);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% hold off
% 
% % Comment out to turn off contour labels:
%  %clabel(c2,h2,'Color',col4)
%  clabel(c3,h3,'Color',col3)
% grid on
% grid minor
% box on
% xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12,'FontName','Times')
% ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12,'FontName','Times')
% % title( 'Earth-to-Mars: C_{3 Earth}','FontSize',12)
% legend({'C_{3 Earth} (km^2/s^2)','TOF (days)'},'Location','northeast','fontsize',10)

%%  graph the contour graphs. 4 C3 for Mars arrival. 
% nexttile
% figure(4)
% 
% hold on
% [c2,h2]=contour(deltDepMesh, deltArrMesh, C3_M/1000^2,C3_levels,'linewidth',1);
% colorbar;
% caxis([min(C3_levels) max(C3_levels)]);
% [c3,h3]=contour(deltDepMesh, deltArrMesh, TOFarray,TOF_levels, 'color', col3);
% hold off
% 
% % Comment out to turn off contour labels:
%  %clabel(c2,h2,'Color',col5)
% clabel(c3,h3,'Color',col3)
% grid on
% grid minor
% box on
% xlabel(['Departure (Days past ', depStr{1},')'],'FontSize',12,'FontName','Times')
% ylabel(['Arrival (Days past ', arrStr{1},')'],'FontSize',12,'FontName','Times')
% % title( 'Earth-to-Mars: C_{3 Earth}','FontSize',12,'FontName','Times')
% legend({'C_{3 Mars} (km^2/s^2)','TOF (days)'},'Location','northeast','fontsize',10,'FontName','Times')