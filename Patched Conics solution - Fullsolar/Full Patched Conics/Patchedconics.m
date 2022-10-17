clear all
clc
%.............PATCHED CONICS SOLUTION FOR INTERPLANETARY TRANSFERS..... 
% Made by Sebastian Rodriguez Rosero, McGill Interstellar Flight Research group,
% Fall 2020.
%Last updated on 12/22/2020

%   Work in progress, algorithm expanded to all the planets in the solar
%   system. 

%!12/22/2020 As far as right now the code presents no error but the values
%Earth to Mars transfers seem to work fine but other planets need validation. 

%ALGORITHMS MAINLY FROM ORBITAL MECHANICS FOR ENGINEERING STUDENTS BY CURTIS.
%  Curtis, H. D. (2005). Chapter 3, 4, 5, 8. In Orbital mechanics for
% engineering students (pp. 107-398). Amsterdam: Butterworth-Heinemann.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  

% All CALCULATIONS HAVE BEEN DONE IN S.I UNITS
%THESE ARE CONVERTED INTO THE MOST CONVENIENT UNIT
%ONCE THE RESULTS ARE DISPLAYED. 

%NOTE: for simplicity, the sufix E refers to planet 1 and M to planet 2 respectively.


%% loading up constants and unit conversion factors.
[units,constant]=unitsandconstants();
%% Initial Parameteres.
%% choose the planets for the patched conics. 
[planetdatadeparture,planetdataarrival,planet1,planet2]=chooseplanet();
%Input date of Departure
[date]=choosedates();
%%   
%Parking orbits around each of the planets, in meters. 
 [rorbitPlanet1, rorbitplanet2, AltitudePlanet1, AltitudePlanet2]=getDAOrbits( units,planetdatadeparture, planetdataarrival);
%% Choose whether to perform a prograde or retrograde trajectory.    
[chooseproretro]=chooseproretro();
%% 
clc
fprintf('                   INTERPLANETARY TRANSFER CALCULATOR \n')
fprintf('=========================================================================\n');
fprintf('                        '); 
fprintf(upper(planet1));
fprintf(' TO ');
fprintf(upper(planet2)); 
fprintf('\n')
fprintf('=========================================================================\n');
%% Get State Vectors: 
[R1,R2,vPlanet1,vPlanet2,TOF]=GetStateVectors(date, constant, units,planetdataarrival,planetdatadeparture);
%% Solve Lambert's
 string =chooseproretro;
[v1,v2]=lambert(R1,R2,TOF,string,constant);

%Parameters of transfer orbit.
GetOrbitParaTransf(R1,v1, constant,units)

%% vector for V1, V2, V hyperbolic depart and arrival. 

[v1mag,v2mag,vhyperDepartVECTOR, vhyperArrivalVECTOR, vhyperDepart, vhyperArrival]=getHyperVel(v1,v2,vPlanet1, vPlanet2);

%% delta Vs. 

[DeltaVplanet1, DeltaVplanet2, vpMh]=GetDVcircular(vhyperDepart, vhyperArrival, planetdatadeparture, planetdataarrival);

%% Eccetricity of the hyperbola

 [e, eM]=getEccentricityHyper(planetdatadeparture,planetdataarrival, vhyperDepart, vhyperArrival);

%% Display results of patched conics
fprintf('\n-------------------------------------------------\n')
fprintf( 'LAUNCH AND ARRIVAL CONDITIONS')
fprintf('\n-------------------------------------------------\n')
fprintf(' Altitude of initial orbit at periapsis= %.1f\tkm \n Altitude of final orbit at periapsis= %.1f\tkm \n TOF= %.1f\tDays \n', AltitudePlanet1, AltitudePlanet2, TOF/units.day);   
fprintf('\n-------------------------------------------------\n')
fprintf( ' RESULTS ');
fprintf('\n-------------------------------------------------\n')
fprintf(' V1= %f\tkm/s \n V2= %f\tkm/s \n Hyperbolic excess leaving planet 1 = %f\tkm/s \n Hyperbolic excess arriving to planet 2 = %f\tkm/s \n Delta V at starting orbit in planet 1= %f\tkm/s \n Delta V for circular final orbit around planet 2= %f\tkm/s \n Eccentricity of hyperbola leaving planet 1= %.4f \n Eccentricity of the hyperbola arriving to planet 2= %.4f \n', v1mag/units.KM, v2mag/units.KM ,vhyperDepart/units.KM, vhyperArrival/units.KM, DeltaVplanet1/units.KM, -DeltaVplanet2/units.KM, e, eM);




%SECTION AHEAD CURRENTLY UNDER RENOVATIONS. 


%Works for some planets. 
while(1)  
   fprintf('would you like to plot this trajectory (y = yes, n = no)\n');
   slct2 = input('? ', 's');
   if (slct2 == 'y' || slct2 == 'n')
      break;
   end 
   fprintf(' \n Oops! \nInvalid input, try again :) \n');
   
end

if slct2 == 'y' 
 GetTransferplot(R1, vPlanet1, R2, vPlanet2,v1,constant,units,planet1,planet2,planetdataarrival, planetdatadeparture);
end
