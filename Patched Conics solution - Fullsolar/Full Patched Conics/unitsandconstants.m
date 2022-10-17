 %% Unit conversion
 function [units, constant]=unitsandconstants()
 units.AU=1.495978707E11; %AU/m
 units.KM=1000; %1000m/km
 units.year=3600*24*365; %s
 units.day=3600*24; %s
 units.RAD=pi/180; %rads
 units.ArcTodeg=1/3600;
 %% Constants
% GM of celestial body. m^3s^-2
constant.mu_sun=1.32712440018E20; %Sun's mu.
 end