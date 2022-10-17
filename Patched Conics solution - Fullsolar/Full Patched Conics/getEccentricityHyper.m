%This function determines the eccentricty of the hyperbolic transfer orbits
%at Earth and Mars. 
%Made by Sebastian Rodriguez Rosero.

function [e, eM]=getEccentricityHyper(planetdatadeparture,planetdataarrival, vhyperDepart, vhyperArrival)

%leaving Earth. 
  e=1+(planetdatadeparture.Radius*vhyperDepart^2)/planetdatadeparture.Mu;
%arriving to Mars
  eM=1+(planetdataarrival.Radius*vhyperArrival^2)/planetdataarrival.Mu; 

end