% This function calculates the starting and final orbits around each of the
% planets. 
%Made by Sebastian Rodriguez Rosero


function [rorbitPlanet1, rorbitplanet2, AltitudePlanet1, AltitudePlanet2]=getDAOrbits( units,planetdatadeparture, planetdataarrival)

    %Initial orbit around planet1, in km.
       AltitudePlanet1=input('Enter the altitude above surface of the departure orbit  in Kilometers: '); %km 

   %Final orbit around planet2, in km.     
   
    AltitudePlanet2=input('Enter the altitude above surface of the arrival orbit  in Kilometers: '); %km
  
    %Orbits around the planets, in meters.
    rorbitPlanet1=AltitudePlanet1*units.KM+planetdatadeparture.Radius;
    rorbitplanet2=planetdataarrival.Radius+AltitudePlanet2*units.KM; %m
    
end