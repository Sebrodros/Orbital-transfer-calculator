% This function determines what the necessary delta V is in order to
% transfer from a Hyperbolic orbit into an elliptic orbit around Mars. It
% depends on the eccentricty and altitude of elliptic orbit at periapsis.
% Made by Sebastian Rodriguez Rosero.

function [aellip, eellip, vpMellip, deltaVmarsEllip]=getHyperToEllip( rorbitMARS, vpMh, constant)
    fprintf('Transfer to elliptic orbit around Mars\n'); 
    eellip=input('Enter eccentricity of the final orbit: '); %Eccentricity of elliptic orbit.
    aellip=rorbitMARS/(1-eellip); % %semimajor axis of elliptic orbit m
    vpMellip=sqrt(constant.MuMARS/rorbitMARS*(1+eellip)); %Velocity at periapsis of elliptic orbit. m/s
    deltaVmarsEllip=vpMh-vpMellip; %Delta V needed to change from hyperbolic into elliptic orbit. m/s
    
    
end  