clc; clear all
%this code will find viable solutions within a launch window: 
%{
It will take as input the year. TOF going, TOF returning and duration in
Mars. 
it will output dates and dV for going and return. 
need two functions, one for going and one for returning. And iterate
through them. 
%}

%%
%Departure to Mars. 
%Departure
dep_info.yearD=2022;
dep_info.monthD=5;
dep_info.dayD=30;
%Arrival:
dep_info.yearA=2022;
dep_info.monthA=6;
dep_info.dayA=30;

%return to earth 
%Departure
ret_info.yearD=2022;
ret_info.monthD=7;
ret_info.dayD=30;

%Arrival:
ret_info.yearA=2022;
ret_info.monthA=8;
ret_info.dayA=30;

%get the dates and dv combinations: 
departure=map_departure(dep_info); 
retur=map_return(ret_info);


%%
contour(departure.JDArrayDep,departure.JDArrayArr,departure.dV_dep);


%% functions: 
%departure calculations: 
function [departure]=map_departure(dep_info)


%Orbits for DV:
AltitudeEARTH=13000; %km
AltitudeMARS=150;  %km

%Date to Julian. 
JD_dep = getJulian(dep_info.yearD, dep_info.monthD, dep_info.dayD);

JD_arr = getJulian(dep_info.yearA,dep_info.monthA,dep_info.dayA);
depDate=datetime(JD_dep,'convertfrom','juliandate','Format','dd-MMM-yyy');
depStr=cellstr(depDate);
arrDate=datetime(JD_arr,'convertfrom','juliandate','Format','dd-MMM-yyy');
arrStr=cellstr(arrDate);
fprintf('Departure to Mars: \n');
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
   
   for i = 1:length(JDArrayDep)
    [rArray_dep(i,:),vArray_dep(i,:)]=GetStateVectorsEARTH(JDArrayDep(i));
   end
   for j = 1:length(JDArrayArr)
     [rArray_arr(j,:),vArray_arr(j,:)]=GetStateVectorsMARS(JDArrayArr(j)) ;
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
        vInf_dep = norm(v1Vec - vArray_dep(i,:)); %m/s
        vInf_arr = norm(v2Vec - vArray_arr(j,:));%m/s
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

%departure data arrays: 
departure.TOF=TOFarray;
departure.dV_dep=dV_dep; 
departure.dV_arr=dV_arr; 
departure.JDArrayDep=JDArrayDep;
departure.JDArrayArr=JDArrayArr; 

clear i j
fprintf('\nDONE!\n') %When the code stops calculating.

end

%return calculations: 
function [retur]=map_return(ret_info)

%altitute for starting orbits: 

AltitudeEARTH=13000; %km
AltitudeMARS=150;  %km

%Date to Julian. 
JD_dep = getJulian(ret_info.yearD,ret_info.monthD,ret_info.dayD);
JD_arr = getJulian(ret_info.yearA,ret_info.monthA,ret_info.dayA);
depDate=datetime(JD_dep,'convertfrom','juliandate','Format','dd-MMM-yyy');
depStr=cellstr(depDate);
arrDate=datetime(JD_arr,'convertfrom','juliandate','Format','dd-MMM-yyy');
arrStr=cellstr(arrDate);
fprintf('Return to Earth: \n');
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

%Return data arrays: 
retur.TOF=TOFarray;
retur.dV_dep=dV_dep; 
retur.dV_arr=dV_arr; 
retur.JDArrayDep=JDArrayDep;
retur.JDArrayArr=JDArrayArr; 

clear i j
fprintf('\nDONE!\n') %When the code stops calculating.

end