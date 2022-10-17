
%Made by Sebastian Rodriguez Rosero for The Interstellar Flight
%Experimental Research Group, fall 2020.
%this function determines the state vectors of the departure and arrival planets at the
%departure and arrival dates. 
%..................................................................
%........Taken from Curtis' Orbital Mechanics for Engineering students

   function [R1,R2,Vplanet1,Vplanet2,TOF]=GetStateVectors(date, constant, units,planetdataarrival,planetdatadeparture)    
%ALGORITHM 8.1
%---------------------------------------------
%Get the Julian date of departure:
JDD=getJulianD(date);
ToD=getCenturyNumD(JDD);

JDA=getJulianA(date);
ToA=getCenturyNumA(JDA);

%Get the departure planets's Orbital elements at the departure date.
[aE, eE, iE, omegaE, wE, LE]=getOrbitalElementsPlanet1(ToD,units,planetdatadeparture);

%Get the arrival planets's Orbital elements at the arrival date.
[aM, eM, iM, omegaM, wM, LM]=getOrbitalElementsPlanet2(ToA,units,planetdataarrival);

%Get the orbits' angular momentum
[hE,hM]=getangularmomentum(constant,aE,aM,eE,eM);

%Get argument of perihelion W and mean anomaly M at JD. 
[WE, WM, ME, MM]=getWandM(wE,wM,omegaE,omegaM,LE,LM);

%Get the eccentric anomaly for each planet's orbit
[EE, EM]=getEccentricAnomaly(eE,eM, ME, MM,units);

%find the true anomaly of each planet. 
[thetaE, thetaM]=getTrueAnomaly(EE, EM, eE,eM);

%Transform angular properties from 8.1 from degrees into RAD for 4.2 
iE=iE*units.RAD; iM=iM*units.RAD;
omegaE=omegaE*units.RAD; omegaM=omegaM*units.RAD;
WE=WE*units.RAD; WM=WM*units.RAD;
thetaE=thetaE*units.RAD; thetaM=thetaM*units.RAD;



%---------------------------------------------
%ALGORITHM 4.2
%---------------------------------------------
%step 1
%%Calculate position vectors in perifocal coordinates
[rxE, rxM]=getposvecPerifocal(hE,hM,eE,constant, eM,thetaE,thetaM);

%step 2
%Calculate velocity vectors in perifocal coordinates 4.38
[vxE, vxM]=getvelvecPerifocal(hE, hM,eE, eM, constant,thetaE, thetaM);

%step 3
%Calculate the conversion matrix from perifocal to heliocentric
%coordinates. 4.44
[QxE,QxM]=getConversionMatrix(WE,WM, omegaE, omegaM, iE, iM);

%step 4
%Convert the position and velocity vectors from perifocal to heliocentric
%coordinates. 
[R1,R2,Vplanet1,Vplanet2]=GetvectorsHeliocent(rxE,rxM,vxE,vxM,QxE,QxM);

%get the travel time.
TOF=getTOF(JDD,JDA);

%display the state vectors. 
fprintf('------------------------------------------\n')
fprintf(' Departure date at : %.0f years, %.0f months, %.0f days, %.0f hours(UT)\n',date.yearD, date.monthD, date.dayD, date.hourD)
fprintf('\n Arrival date at Mars: %.0f years, %.0f months, %.0f days, %.0f hours(UT)\n',date.yearA, date.monthA, date.dayA, date.hourA)
fprintf('------------------------------------------\n')
fprintf('------------------------------------------')
fprintf(' \n Orbital Parameters of departure planet orbit \n')
fprintf('------------------------------------------\n')
fprintf(' Semimajor axis=%f AU \n Eccentricity= %f \n Inclination= %f deg \n Right Ascension= %f deg \n Longitude of Perihelion= %f deg \n Mean longitude= %f deg', aE/units.AU, eE, iE/units.RAD, omegaE/units.RAD, wE/units.RAD, LE);
fprintf('\n Angular Momentum= %f km^2/s \n Argument of Perihelion= %f deg \n Mean Anomaly= %f deg \n Eccentric Anomaly= %f deg \n True Anomaly= %f deg \n', hE/units.KM, WE/units.RAD, ME,EE, thetaE/units.RAD);
fprintf('\n------------------------------------------\n')
fprintf(' Departure Planet State Vectors  \n')
fprintf('------------------------------------------')
fprintf('\n R1=(%f i, %f j, %f k) km \n r1= %f km\n',R1.'/units.KM, norm(R1)/units.KM)
fprintf('\n V=(%f i, %f j, %f k) km/s\n V(mag)= %f km/s\n',Vplanet1.'/units.KM, norm(Vplanet1)/units.KM)
fprintf('------------------------------------------\n')
fprintf('------------------------------------------')
fprintf(' \n Orbital Parameters of Arrival Planet orbit \n')
fprintf('------------------------------------------\n')
fprintf(' Semimajor axis=%f AU \n Eccentricity= %f \n Inclination= %f deg \n Right Ascension= %f deg \n Longitude of Perihelion= %f deg \n Mean longitude= %f deg', aM/units.AU, eM, iM/units.RAD, omegaM/units.RAD, wM/units.RAD, LM);
fprintf('\n Angular Momentum= %f km^2/s \n Argument of Perihelion= %f deg \n Mean Anomaly= %f deg \n Eccentric Anomaly= %f deg \n True Anomaly= %f deg \n', hM/units.KM, WM/units.RAD, MM,EM, thetaM/units.RAD);

fprintf('\n------------------------------------------\n')
fprintf('Arrival Planet State Vectors  \n')
fprintf('------------------------------------------')
fprintf('\n R2=(%f i, %f j, %f k) km\n r2= %f km\n',R2.'/units.KM, norm(R2)/units.KM)
fprintf('\n V=(%f i, %f j, %f k) km/s\n V(mag)= %f km/s\n',Vplanet2.'/units.KM,norm(Vplanet2)/units.KM)


%%FUNCTIONS 
%ALGORITHM 8.1
%-----------------------------------------
%Departure date Earth
%-----------------------------------------
%Step 1
%Gregorian to Julian date 
function JDD=getJulianD(date)
JoD=367*date.yearD-floor(((7*(date.yearD+floor((date.monthD+9)/12))/4)))+floor(275*date.monthD/9)+date.dayD+1721013.5;
UTD=date.hourD; %in hours. Universal time.
JDD=JoD+UTD/24; %days
end
function JDA=getJulianA(date)
    JoA=367*date.yearA-floor(((7*(date.yearA+floor((date.monthA+9)/12))/4)))+floor(275*date.monthA/9)+date.dayA+1721013.5;
    UTA=date.hourA; %in hours. Universal time.
    JDA=JoA+UTA/24; %days
end 
%Step 2
%time from J2000
function To=getCenturyNumD(JD)
To=(JD-2451545)/36525;
end
function ToA=getCenturyNumA(JDA)
    ToA=(JDA-2451545)/36525;
end
%Step 3
%Finds the orbital elements
function [aE, eE, iE, omegaE, wE, LE]=getOrbitalElementsPlanet1(ToD,units,planetdatadeparture)

%the tabulated value (dot) had to be converted from arc seconds 
%to degrees by diving by 3600

    aE=(planetdatadeparture.aAU+(planetdatadeparture.aAURATE)*ToD)*units.AU; %m
    eE=planetdatadeparture.eccentricity+(planetdatadeparture.eccentricityRATE)*ToD;
    iE=zero_to_360((planetdatadeparture.inclination+(planetdatadeparture.inclinationRATE*units.ArcTodeg)*ToD));%degree ///////////////////////////////////////////////////// 
    omegaE=zero_to_360(planetdatadeparture.RAAN+(planetdatadeparture.RAANRATE*units.ArcTodeg)*ToD);%degree 
    wE=zero_to_360(planetdatadeparture.LPerihelion+(planetdatadeparture.LPerihelionRATE*units.ArcTodeg)*ToD);%degree 
    LE=zero_to_360(planetdatadeparture.MLongitude+(planetdatadeparture.MLongitudeRATE*units.ArcTodeg)*ToD);%degree
    end

function [aM, eM, iM, omegaM, wM, LM]=getOrbitalElementsPlanet2(ToA,units,planetdataarrival)
    aM=(planetdataarrival.aAU+(planetdataarrival.aAURATE)*ToA)*units.AU; %m
    eM=planetdataarrival.eccentricity+(planetdataarrival.eccentricityRATE)*ToA;
    iM=zero_to_360(planetdataarrival.inclination+(planetdataarrival.inclinationRATE*units.ArcTodeg)*ToA);%degree
    omegaM=zero_to_360(planetdataarrival.RAAN+(planetdataarrival.RAANRATE*units.ArcTodeg)*ToA);%degree
    wM=zero_to_360(planetdataarrival.LPerihelion+(planetdataarrival.LPerihelionRATE*units.ArcTodeg)*ToA);%degree
    LM=zero_to_360(planetdataarrival.MLongitude+(planetdataarrival.MLongitudeRATE*units.ArcTodeg)*ToA);%degree
    
end

%step 4
%Get the angular momentum h for each planet. 
function [hE,hM]=getangularmomentum(constant,aE,aM,eE,eM)
hE=sqrt(constant.mu_sun*aE*(1-eE^2));
hM=sqrt(constant.mu_sun*aM*(1-eM^2));

end
%step 5
%Get argument of perihelion W and mean anomaly M at JD.
function [WE, WM, ME, MM]=getWandM(wE,wM,omegaE,omegaM,LE,LM)
WE=zero_to_360(wE-omegaE); %degree
WM=zero_to_360(wM-omegaM);%degree
ME=zero_to_360(LE-wE);%degree
MM=zero_to_360(LM-wM);%degree

end
%step 6
%Get the eccentric anomaly for each planet's orbit
function [EE, EM]=getEccentricAnomaly(eE,eM, ME, MM,units)

ee=@(EE) EE-eE*sin(EE)-ME*units.RAD;
EE=fzero(ee,0)*1/units.RAD;

em=@(EM) EM-eM*sin(EM)-MM*units.RAD;
EM=fzero(em,0)*1/units.RAD;
end
%step 7
%find the true anomaly of each planet. 
function [thetaE, thetaM]=getTrueAnomaly(EE, EM, eE,eM)
thetaE=zero_to_360(2*atand(tand(EE/2)/sqrt((1-eE)/(1+eE))));
thetaM=zero_to_360(2*atand(tand(EM/2)/sqrt((1-eM)/(1+eM))));
end
%-----------------------------------------
%ALGORITHM 4.2 All angular properties have to be on RAD to work!!!!
%-----------------------------------------
%step 1
%Calculate position vectors in perifocal coordinates 4.37
function [rxE, rxM]=getposvecPerifocal(hE,hM,eE,constant,eM,thetaE,thetaM)

rxE=(hE^2/constant.mu_sun)*(1/(1+eE*cos(thetaE)))*[cos(thetaE); sin(thetaE); 0];
rxM= (hM^2/constant.mu_sun)*(1/(1+eM*cos(thetaM)))*[cos(thetaM); sin(thetaM); 0];

end
%step 2
%Calculate velocity vectors in perifocal coordinates 4.38
function [vxE, vxM]=getvelvecPerifocal(hE, hM,eE, eM, constant,thetaE, thetaM)
vxE=constant.mu_sun/hE*[-sin(thetaE); eE+cos(thetaE); 0]; 
vxM=constant.mu_sun/hM*[-sin(thetaM); eM+cos(thetaM); 0];
end

%step 3
%Calculate the conversion matrix from perifocal to heliocentric
%coordinates. 4.44
function [QxE,QxM]=getConversionMatrix(WE,WM, omegaE, omegaM, iE, iM)
    
R3OmegaE=[cos(omegaE) sin(omegaE) 0
         -sin(omegaE) cos(omegaE) 0
            0            0           1 ];
        
R1iE=[1        0          0
      0  cos(iE)    sin(iE)
      0  -sin(iE)  cos(iE)];
  
R3WE=[cos(WE)  sin(WE) 0
      -sin(WE) cos(WE) 0
       0          0      1];
   
QxE=(R3WE*R1iE*R3OmegaE).';  

R3OmegaM=[cos(omegaM) sin(omegaM) 0
         -sin(omegaM) cos(omegaM) 0
            0            0           1  ];
        
R1iM=[1        0          0
      0  cos(iM)    sin(iM)
      0  -sin(iM)  cos(iM)];
  
R3WM=[cos(WM)  sin(WM) 0
      -sin(WM) cos(WM) 0
       0          0      1];


QxM=(R3WM*R1iM*R3OmegaM).';  

end

function[R1,R2,Vplanet1,Vplanet2]=GetvectorsHeliocent(rxE,rxM,vxE,vxM,QxE,QxM)
R1=QxE*rxE;
R2=QxM*rxM;

Vplanet1=QxE*vxE;
Vplanet2=QxM*vxM;
end

function TOF=getTOF(JDD,JDA)
    TOF=JDA-JDD;
    TOF=TOF*24*3600;
end


%Wraps the angles in between 0 to 360 degrees. 
function y = zero_to_360(x)
if x >= 360
x = x - fix(x/360)*360;
elseif x < 0
x = x - (fix(x/360) - 1)*360;
end
y = x;
end
end