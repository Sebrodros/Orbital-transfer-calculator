% This function calculates the delta V necessary to get into the hyperbolic
% transfer orbit and leave it. The result depends on the initial and final
% orbit. Made by Sebastian Rodriguez Rosero.

function [DeltaVplanet1, DeltaVplanet2, vpMh]=GetDVcircular(vhyperDepart, vhyperArrival, planetdatadeparture, planetdataarrival)
    %% Circular starting orbit at planet 1
    vpE=sqrt(vhyperDepart^2+(2*planetdatadeparture.Mu)/planetdatadeparture.Radius); %speed at periapsis of transfer orbit m/s
    vcE=sqrt(planetdatadeparture.Mu/planetdatadeparture.Radius); %circular speed of the parking orbit. m/s
    DeltaVplanet1=vpE-vcE; %m/s
    
    %% Circular final orbit at planet 2
    vpMh=sqrt(vhyperArrival^2+(2*planetdataarrival.Mu)/planetdataarrival.Radius);%speed at periapsis of transfer orbit m/s
    vcM=sqrt(planetdataarrival.Mu/planetdataarrival.Radius); %circular speed of the parking orbit. m/s
    DeltaVplanet2=vcM-vpMh; %m/s
    
end