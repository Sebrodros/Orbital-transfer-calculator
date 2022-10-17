%DATABASE OF DATA FROM PLANETS IN THE SOLAR SYSTEM. 
%TO BE USED IN PATCHED CONICS CALCULATIONS. 
%Made by Sebastian Rodriguez Rosero for the Interstellar Flight research
%group, McGill University. Fall 2020. 



function [planetdata]=setPlanetDatabase(Planet)
planetdata.Mu=NaN; %km^3/s^2
planetdata.go=NaN;
planetdata.Radius=NaN;
planetdata.SOI=NaN;
planetdata.aAU=NaN;          %AU
planetdata.aAURATE=NaN;      %AU/Cy
planetdata.eccentricity=NaN; 
planetdata.eccentricityRATE=NaN; %1/Cy
planetdata.inclination=NaN;  %deg
planetdata.inclinationRATE=NaN; %''/Cy
planetdata.RAAN=NaN;         %deg
planetdata.RAANRATE=NaN;       %''/Cy
planetdata.LPerihelionRATE=NaN;
planetdata.LPerihelion=NaN;    %''/Cy
planetdata.MLongitude=NaN;     %deg
planetdata.MLongitudeRATE=NaN; %''/Cy
planetdata.color=NaN; %Sets the color of the orbit. 


    if upper(Planet)== "MERCURY"
        planetdata.color=[0.75, 0.75, 0];
        planetdata.Mu=2.2032e13;      %m^3/s^2
        planetdata.go=3.71;      %m/s
        planetdata.Radius=2439500;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=47.4; %km/s
        
        planetdata.aAU=0.38709893;          %AU
        planetdata.aAURATE=0.00000066;      %AU/Cy
        
        planetdata.eccentricity=0.20563069;         
        planetdata.eccentricityRATE=0.00002527; %1/Cy
        
        planetdata.inclination=7.00487;     %deg
        planetdata.inclinationRATE=-23.51;  %''/Cy
        
        planetdata.RAAN=48.33167;            %deg
        planetdata.RAANRATE=-446.30;         %''/Cy

        
        planetdata.LPerihelion=77.45645;    %deg
        planetdata.LPerihelionRATE=573.57;    %''/Cy
        
        planetdata.MLongitude=252.25084;     %deg
        planetdata.MLongitudeRATE=538101628.29; %''/Cy
    end
    
    if upper(Planet)== "VENUS"
        planetdata.color=[0.9290, 0.6940, 0.1250];
        planetdata.Mu=3.24859e14;      %m^3/s^2
        planetdata.go=4.87;                %m/s
        planetdata.Radius=6052e3;           %m
        planetdata.SOI=NaN;                  %m
        planetdata.Orbitalvelocity=35.0; %km/s

        
        planetdata.aAU=0.72333199;          %AU
        planetdata.aAURATE=0.00000092;      %AU/Cy
        
        planetdata.eccentricity=0.00677323; 
        planetdata.eccentricityRATE=-0.00004938; %1/Cy
        
        planetdata.inclination=3.39471;         %deg
       planetdata.inclinationRATE=-2.86;        %''/Cy
        
        planetdata.RAAN=76.68069;           %deg
        planetdata.RAANRATE=-996.89;        %''/Cy

        
        planetdata.LPerihelion=131.53298;   %deg
        planetdata.LPerihelionRATE=-108.80;         %''/Cy
        
        planetdata.MLongitude=181.97973;     %deg
        planetdata.MLongitudeRATE=210664136.06; %''/Cy
    end
    
    if upper(Planet)== "EARTH"
        
        planetdata.color=[0, 0, 1];
        planetdata.Mu=3.986004418e14;      %m^3/s^2
        planetdata.go=9.81;      %m/s
        planetdata.Radius=6378e3;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=29.8; %km/s

        
        planetdata.aAU=1.00000011;                    %AU
        planetdata.aAURATE=-0.00000005;              %AU/Cy
        
        planetdata.eccentricity=0.01671022; 
        planetdata.eccentricityRATE=-0.00003804;      %1/Cy
        
        planetdata.inclination=0.00005;               %deg
        planetdata.inclinationRATE=-46.94;           %''/Cy
        
        planetdata.RAAN=-11.26064;                    %deg
        planetdata.RAANRATE=-18228.25;                %''/Cy

        
        planetdata.LPerihelion=102.94719;
        planetdata.LPerihelionRATE=1198.28;               %''/Cy
        
        planetdata.MLongitude=100.46435;              %deg
        planetdata.MLongitudeRATE=129597740.63;       %''/Cy

    end
    
    if upper(Planet)== "MARS"
        planetdata.color=[0.8500, 0.3250, 0.0980];
        planetdata.Mu=4.282837e13;      %m^3/s^2
        planetdata.go=3.71;      %m/s
        planetdata.Radius=3396e3;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=24.1; %km/s

        planetdata.aAU=1.52366231;          %AU
        planetdata.aAURATE=-0.00007221;      %AU/Cy
        
        planetdata.eccentricity=0.09341233; 
        planetdata.eccentricityRATE=0.00011902; %1/Cy
        
        planetdata.inclination=1.85061;       %deg
        planetdata.inclinationRATE=-25.47;   %''/Cy
        
        planetdata.RAAN=49.57854;            %deg
        planetdata.RAANRATE=-1020.19;        %''/Cy

        
        planetdata.LPerihelion=336.04084;    %deg
        planetdata.LPerihelionRATE=1560.78;       %''/Cy
        
        planetdata.MLongitude=355.45332;     %deg
        planetdata.MLongitudeRATE=68905103.78; %''/Cy
    end
    
    if upper(Planet)== "JUPITER"
        planetdata.color=[0.6350, 0.0780, 0.1840];
        
        planetdata.Mu=1.26686534e17;      %m^3/s^2
        planetdata.go=23.1;      %m/s
        planetdata.Radius=71492e3;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=13.1; %km/s

        planetdata.aAU=5.20336301;          %AU
        planetdata.aAURATE=0.00060737;      %AU/Cy
        
        planetdata.eccentricity=0.04839266; 
        planetdata.eccentricityRATE=-0.00012880; %1/Cy
        
        planetdata.inclination=1.30530;  %deg
        planetdata.inclinationRATE=-4.15; %''/Cy
        
        planetdata.RAAN=100.55615;         %deg
        planetdata.RAANRATE=1217.17;       %''/Cy

        
        planetdata.LPerihelion=14.75385; %deg
        planetdata.LPerihelionRATE=839.93;    %''/Cy
        
        planetdata.MLongitude=34.40438;     %deg
        planetdata.MLongitudeRATE=10925078.35; %''/Cy 
    end
    
    if upper(Planet)== "SATURN"
        
        planetdata.color= [0.4940, 0.1840, 0.5560];
        planetdata.Mu=3.793939e15;      %m^3/s^2
        planetdata.go=9.0;      %m/s
        planetdata.Radius=60268e3;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=9.7; %km/s

        
        planetdata.aAU=9.53707032;           %AU
        planetdata.aAURATE=-0.00301530;      %AU/Cy
        
        planetdata.eccentricity=0.05415060; 
        planetdata.eccentricityRATE=-0.00036762; %1/Cy
        
        planetdata.inclination=2.48446;      %deg
        planetdata.inclinationRATE=6.11;     %''/Cy
        
        planetdata.RAAN=113.71504;           %deg
        planetdata.RAANRATE=-1591.05;        %''/Cy

        
        planetdata.LPerihelion=92.43194;  %deg
        planetdata.LPerihelionRATE=-1948.89;      %''/Cy
        
        planetdata.MLongitude=49.94432;       %deg
        planetdata.MLongitudeRATE=4401052.95; %''/Cy
    end
    
    if upper(Planet)== "URANUS"
        planetdata.color=[0, 0.4470, 0.7410];
        planetdata.Mu=5.793939e15;      %m^3/s^2
        planetdata.go=8.7;      %m/s
        planetdata.Radius=25559e3;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=6.8; %km/s

        planetdata.aAU=19.19126393;          %AU
        planetdata.aAURATE=0.00152025;       %AU/Cy
        
        planetdata.eccentricity=0.04716771; 
        planetdata.eccentricityRATE=-0.00019150; %1/Cy
        
        planetdata.inclination=0.76986;   %deg
        planetdata.inclinationRATE=-2.09; %''/Cy
        
        planetdata.RAAN=74.22988;         %deg
        planetdata.RAANRATE=-1681.4;      %''/Cy

        
        planetdata.LPerihelion=170.96424; %deg
        planetdata.LPerihelionRATE=1312.56;       %''/Cy
        
        planetdata.MLongitude=313.23218;      %deg
        planetdata.MLongitudeRATE=1542547.79; %''/Cy
    end
    
    if upper(Planet)== "NEPTUNE"
        planetdata.color=[0.25, 0.25, 0.25];
        planetdata.Mu=6.836529e15;      %m^3/s^2
        planetdata.go=11.0;      %m/s
        planetdata.Radius=24764;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=5.4; %km/s

        
        planetdata.aAU=30.06896348;          %AU
        planetdata.aAURATE=-0.00125196;      %AU/Cy
        
        planetdata.eccentricity=0.00858587; 
        planetdata.eccentricityRATE=0.00002514; %1/Cy
        
        planetdata.inclination=1.76917;  %deg
        planetdata.inclinationRATE=-3.64; %''/Cy
        
        planetdata.RAAN=131.72169;         %deg
        planetdata.RAANRATE=-151.25;        %''/Cy

        
        planetdata.LPerihelion=44.97135; %deg
        planetdata.LPerihelionRATE=-844.43;    %''/Cy
        
        planetdata.MLongitude=304.88003;     %deg
        planetdata.MLongitudeRATE=786449.21; %''/Cy
    end
    
    if upper(Planet)== "PLUTO"
        planetdata.color=[0, 0.5, 0];
        planetdata.Mu=8.71e11;      %m^3/s^2
        planetdata.go=0.7;      %m/s
        planetdata.Radius=1185e3;  %m
        planetdata.SOI=NaN;     %m
        planetdata.Orbitalvelocity=4.7; %km/s

        
        planetdata.aAU=39.48168677;          %AU
        planetdata.aAURATE=-0.00076912;      %AU/Cy
        
        planetdata.eccentricity=0.24880766; 
        planetdata.eccentricityRATE=0.00006465; %1/Cy
        
        planetdata.inclination=17.14175;  %deg
        planetdata.inclinationRATE=11.07; %''/Cy
        
        planetdata.RAAN=110.30347;         %deg
        planetdata.RAANRATE=-37.33;        %''/Cy

        
        planetdata.LPerihelion=224.06676; %deg
        planetdata.LPerihelionRATE=-132.25;    %''/Cy
        
        planetdata.MLongitude=238.92881;     %deg
        planetdata.MLongitudeRATE=522747.90; %''/Cy
    end

end