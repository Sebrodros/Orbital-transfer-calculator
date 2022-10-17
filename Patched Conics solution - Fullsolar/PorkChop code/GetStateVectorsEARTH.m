function [R1,vEarth]=GetStateVectorsEARTH(JD_dep)    
   
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
%Get the Julian date of departure:
   ToD=getCenturyNumD(JD_dep);
%Get the  Earth's Orbital elements at the departure date.
[aE, eE, iE, omegaE, wE, LE]=getOrbitalElementsEarth(ToD);
%Get the orbits' angular momentum
[hE]=getangularmomentum(mu,aE,eE);
%Get argument of perihelion W and mean anomaly M at JD. 
[WE, ME]=getWandM(wE,omegaE,LE);
%Get the eccentric anomaly for each planet's orbit
[EE]=getEccentricAnomaly(eE, ME);
%find the true anomaly of each planet. 
[thetaE]=getTrueAnomaly(EE,eE);
%Transform angular properties from 8.1 from degrees into RAD for 4.2 
iE=iE*RAD; 
omegaE=omegaE*RAD;
WE=WE*RAD; 
thetaE=thetaE*RAD; 



%---------------------------------------------
%ALGORITHM 4.2
%---------------------------------------------
%step 1
%%Calculate position vectors in perifocal coordinates
[rxE]=getposvecPerifocal(hE,eE,mu,thetaE);
%step 2
%Calculate velocity vectors in perifocal coordinates 4.38
[vxE]=getvelvecPerifocal(hE,eE, mu,thetaE);
%step 3
%Calculate the conversion matrix from perifocal to heliocentric
%coordinates. 4.44
[QxE]=getConversionMatrix(WE, omegaE,iE);
%step 4
%Convert the position and velocity vectors from perifocal to heliocentric
%coordinates. 
[R1,vEarth]=GetvectorsHeliocent(rxE,vxE,QxE);

%%FUNCTIONS 
%ALGORITHM 8.1
%-----------------------------------------
%Departure date Earth
%-----------------------------------------
%Step 1
%Gregorian to Julian date 

%Step 2
%time from J2000
function To=getCenturyNumD(JD_dep)
To=(JD_dep-2451545)/36525;
end
%Step 3
%Finds the orbital elements
function [aE, eE, iE, omegaE, wE, LE]=getOrbitalElementsEarth(ToD)

%the tabulated value (dot) had to be converted from arc seconds 
%to degrees by diving by 3600
AU=1.495978707E11; ArcTodeg=1/3600;

aE=(1.00000011+(-0.00000005)*ToD)*AU; %m
eE=0.01671022+(-0.00003804)*ToD;
iE=zero_to_360((0.00005+(-46.94*ArcTodeg)*ToD));%degree ///////////////////////////////////////////////////// 
omegaE=zero_to_360(-11.26064+(-18228.25*ArcTodeg)*ToD);%degree 
wE=zero_to_360(102.94719+(1198.28*ArcTodeg)*ToD);%degree 
LE=zero_to_360(100.46435+(129597740.63*ArcTodeg)*ToD);%degree
end
%step 4
%Get the angular momentum h for each planet. 
function [hE]=getangularmomentum(mu,aE,eE)
hE=sqrt(mu*aE*(1-eE^2));

end
%step 5
%Get argument of perihelion W and mean anomaly M at JD.
function [WE, ME]=getWandM(wE,omegaE,LE)
WE=zero_to_360(wE-omegaE); %degree
ME=zero_to_360(LE-wE);%degree
end
%step 6
%Get the eccentric anomaly for each planet's orbit
function [EE]=getEccentricAnomaly(eE, ME)

ee=@(EE) EE-eE*sin(EE)-ME*pi/180;
EE=fzero(ee,0)*180/pi;

end
%step 7
%find the true anomaly of each planet. 
function [thetaE]=getTrueAnomaly(EE,eE)
thetaE=zero_to_360(2*atand(tand(EE/2)/sqrt((1-eE)/(1+eE))));
end
%-----------------------------------------
%ALGORITHM 4.2 All angular properties have to be on RAD to work!!!!
%-----------------------------------------
%step 1
%Calculate position vectors in perifocal coordinates 4.37
function [rxE ]=getposvecPerifocal(hE,eE,mu,thetaE)

rxE=(hE^2/mu)*(1/(1+eE*cos(thetaE)))*[cos(thetaE); sin(thetaE); 0];

end
%step 2
%Calculate velocity vectors in perifocal coordinates 4.38
function [vxE]=getvelvecPerifocal(hE, eE,  mu,thetaE)
vxE=mu/hE*[-sin(thetaE); eE+cos(thetaE); 0]; 
end

%step 3
%Calculate the conversion matrix from perifocal to heliocentric
%coordinates. 4.44
function [QxE]=getConversionMatrix(WE, omegaE, iE)
    
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


end

function[R1,Vearth]=GetvectorsHeliocent(rxE,vxE,QxE)
R1=QxE*rxE;
Vearth=QxE*vxE;
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
