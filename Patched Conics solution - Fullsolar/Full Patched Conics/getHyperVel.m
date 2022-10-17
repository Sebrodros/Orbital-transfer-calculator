% This function determines the hyperbolic excess velocity after the results
% from Lambert's problem. It provides this in the form of a vector and
% magnitude. 
%Made by Sebastian Rodriguez Rosero.

function [v1mag,v2mag,vhyperDepartVECTOR, vhyperArrivalVECTOR, vhyperDepart, vhyperArrival]=getHyperVel(v1,v2,vPlanet1, vPlanet2)
%Excess hyperbolic speed. 
    v1mag=norm(v1);
    v2mag=norm(v2);
    vhyperDepartVECTOR=v1-vPlanet1; %m/s
    vhyperArrivalVECTOR=v2-vPlanet2; %m/s
    vhyperDepart=norm(v1-vPlanet1);%m/s
    vhyperArrival=norm(v2-vPlanet2);%m/s
    
end 