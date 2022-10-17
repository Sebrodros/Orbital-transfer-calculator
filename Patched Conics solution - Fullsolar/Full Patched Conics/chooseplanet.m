%This function will allow us to load up the constants depending on 
%the departure and arrival planet. 
function [planetdatadeparture,planetdataarrival,planet1,planet2]=chooseplanet()
    fprintf('                        INTERPLANETARY TRANSFER CALCULATOR \n')
    fprintf('=========================================================================\n');
    fprintf('Please choose from the following planets for the transfer: \n-Mercury \n-Venus \n-Earth \n-Mars \n-Jupiter \n-Saturn \n-Uranus \n-Neptune \n-Pluto')
    fprintf('\n=========================================================================\n');

    fprintf('\n1) Departure planet: \n')

             planet1 = input('? ','s');
            [planetdatadeparture]=setPlanetDatabase(planet1);

    fprintf('\n2) Arrival planet: \n')
               planet2 = input('? ','s');
            [planetdataarrival]=setPlanetDatabase(planet2);
end