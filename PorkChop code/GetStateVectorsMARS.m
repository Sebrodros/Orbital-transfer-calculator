function [R2,vMars]=GetStateVectorsMARS(JD_arr)    
   
%Conversions 
global AU RAD ArcTodeg KM
AU=1.495978707E11; %AU/m
ArcTodeg=1/3600;
RAD=pi/180;
KM=1000;

%Constants
global mu 
% GM of each celestial body. km^3s^-2
mu=1.327124400189E20; %Sun's mu. %using less to see if that fixes it. 


%ALGORITHM 8.1
%---------------------------------------------
%Get the Julian date of Arrival:
    ToA=getCenturyNumA(JD_arr);
%Get the  Earth's Orbital elements at the arrival date.
[aM, eM, iM, omegaM, wM, LM]=getOrbitalElementsMars(ToA);
%Get the orbits' angular momentum
[hM]=getangularmomentum(mu,aM,eM);
%Get argument of perihelion W and mean anomaly M at JD. 
[ WM, MM]=getWandM(wM,omegaM,LM);
%Get the eccentric anomaly for each planet's orbit
[EM]=getEccentricAnomaly(eM, MM);
%find the true anomaly of each planet. 
[thetaM]=getTrueAnomaly( EM, eM);
%Transform angular properties from 8.1 from degrees into RAD for 4.2 
 iM=iM*RAD;
 omegaM=omegaM*RAD;
 WM=WM*RAD;
 thetaM=thetaM*RAD;



%---------------------------------------------
%ALGORITHM 4.2
%---------------------------------------------
%step 1
%%Calculate position vectors in perifocal coordinates
[ rxM]=getposvecPerifocal(hM,mu, eM,thetaM);
%step 2
%Calculate velocity vectors in perifocal coordinates 4.38
[ vxM]=getvelvecPerifocal( hM, eM, mu, thetaM);
%step 3
%Calculate the conversion matrix from perifocal to heliocentric
%coordinates. 4.44
[QxM]=getConversionMatrix(WM, omegaM, iM);
%step 4
%Convert the position and velocity vectors from perifocal to heliocentric
%coordinates. 
[R2,vMars]=GetvectorsHeliocent(rxM,vxM,QxM);


%%FUNCTIONS 
%ALGORITHM 8.1
%-----------------------------------------
%Departure date Earth
%-----------------------------------------


function ToA=getCenturyNumA(JD_arr)
    ToA=(JD_arr-2451545)/36525;
end

function [aM, eM, iM, omegaM, wM, LM]=getOrbitalElementsMars(ToA)

    %the tabulated value (dot) had to be converted from arc seconds 
    %to degrees by diving by 3600
    AU=1.495978707E11; ArcTodeg=1/3600;

    aM=(1.52366231+(-0.00007221)*ToA)*AU; %m
    eM=0.09341233+(0.00011902)*ToA;
    iM=zero_to_360(1.85061+(-25.47*ArcTodeg)*ToA);%degree
    omegaM=zero_to_360(49.57854+(-1020.19*ArcTodeg)*ToA);%degree
    wM=zero_to_360(336.04084+(1560.78*ArcTodeg)*ToA);%degree
    LM=zero_to_360(355.45332+(68905103.78*ArcTodeg)*ToA);%degree
end
%step 4
%Get the angular momentum h for each planet. 
function [hM]=getangularmomentum(mu,aM,eM)

hM=sqrt(mu*aM*(1-eM^2));

end
%step 5
%Get argument of perihelion W and mean anomaly M at JD.
function [ WM, MM]=getWandM(wM,omegaM,LM)

WM=zero_to_360(wM-omegaM);%degree

MM=zero_to_360(LM-wM);%degree
end
%step 6
%Get the eccentric anomaly for each planet's orbit
function [ EM]=getEccentricAnomaly(eM, MM)
    
em=@(EM) EM-eM*sin(EM)-MM*pi/180;
EM=fzero(em,0)*180/pi;
end
%step 7
%find the true anomaly of each planet. 
function [ thetaM]=getTrueAnomaly( EM, eM)

thetaM=zero_to_360(2*atand(tand(EM/2)/sqrt((1-eM)/(1+eM))));
end
%-----------------------------------------
%ALGORITHM 4.2 All angular properties have to be on RAD to work!!!!
%-----------------------------------------
%step 1
%Calculate position vectors in perifocal coordinates 4.37
function [ rxM]=getposvecPerifocal(hM,mu, eM,thetaM)

rxM= (hM^2/mu)*(1/(1+eM*cos(thetaM)))*[cos(thetaM); sin(thetaM); 0];

end
%step 2
%Calculate velocity vectors in perifocal coordinates 4.38
function [vxM]=getvelvecPerifocal( hM, eM, mu, thetaM)

vxM=mu/hM*[-sin(thetaM); eM+cos(thetaM); 0];
end

%step 3
%Calculate the conversion matrix from perifocal to heliocentric
%coordinates. 4.44
function [QxM]=getConversionMatrix(WM, omegaM,iM)
    

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

function[R2,Vmars]=GetvectorsHeliocent(rxM,vxM,QxM)

R2=QxM*rxM;

Vmars=QxM*vxM;
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