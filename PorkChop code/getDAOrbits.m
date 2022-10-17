% This function calculates the starting and final orbits around each of the
% planets. At Earth's this orbit depends on the range of the laser array.
% At Mars, the orbit can be chosen freely.
%Made by Sebastian Rodriguez Rosero
%Code is set up for input starting orbit, it can be easily changed to work
%depending on the laser array's angular velocity. 

function [rorbitEARTH, rorbitMARS, AltitudeEARTH, AltitudeMARS]=getDAOrbits(constant, units,AltitudeEARTH, AltitudeMARS)
    %%Choosing the starting orbit
%     
%         OmegaEarth=15/3600*units.RAD; %rad
%         OmegaGimble=input('Enter the range of the laser, in degrees: ')/3600*units.RAD; %rad
%         omegaLaserRAD= OmegaEarth+OmegaGimble;
%         
%         rorbitEARTH=((sqrt(constant.MuEARTH)/omegaLaserRAD)^(2/3));%in meters.
%        AltitudeEARTH=input('Enter the altitude above surface of the departure orbit at Earth, in Kilometers: '); %km 
% 
%    %Final orbit around Mars, in kilometers.     
%    
%     AltitudeMARS=input('Enter the altitude above surface of the arrival orbit at Mars, in Kilometers: '); %km
%   
    %Orbits around the planets, in meters.
    rorbitEARTH=AltitudeEARTH*units.KM+constant.RGroundEarth;
    rorbitMARS=constant.RGroundMars+AltitudeMARS*units.KM; %m
    
end