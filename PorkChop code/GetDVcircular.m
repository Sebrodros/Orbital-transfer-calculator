% This function calculates the delta V necessary to get into the hyperbolic
% transfer orbit and leave it. The result depends on the initial and final
% orbit. Made by Sebastian Rodriguez Rosero.

function [DeltaVearth, DeltaVmars , vpMh]=GetDVcircular(vhyperDepart, vhyperArrival, AltitudeEARTH, AltitudeMARS)
 %% Unit conversion
 units.AU=1.495978707E11; %AU/m
 units.KM=1000; %1000m/km
 units.year=3600*24*365; %s
 units.day=3600*24; %s
 units.RAD=pi/180; %rads
 units.ArcTodeg=1/3600;
%% Constants
% GM of each celestial body. m^3s^-2
constant.mu=1.32712440018E20; %Sun's mu.
constant.MuEARTH= 3.986004418E14; 
constant.MuMARS= 4.282837E13;

% Radius of planets, in meters.
constant.RGroundEarth=6371*units.KM; %m
constant.RGroundMars= 3389.5*units.KM;%m
%%
[rorbitEARTH, rorbitMARS]=getDAOrbits(constant, units,AltitudeEARTH, AltitudeMARS);

    %% Circular starting orbit at EARTH
    vpE=sqrt(vhyperDepart^2+(2*constant.MuEARTH)/rorbitEARTH); %speed at periapsis of transfer orbit m/s
    vcE=sqrt(constant.MuEARTH/rorbitEARTH); %circular speed of the parking orbit. m/s
    DeltaVearth=vpE-vcE; %m/s
    DeltaVearth=DeltaVearth/units.KM;
    
    %% Circular final orbit at MARS
    vpMh=sqrt(vhyperArrival^2+(2*constant.MuMARS)/rorbitMARS);%speed at periapsis of transfer orbit m/s
    vcM=sqrt(constant.MuMARS/rorbitMARS); %circular speed of the parking orbit. m/s
    DeltaVmars=vcM-vpMh; %m/s
    DeltaVmars=DeltaVmars/units.KM;
end