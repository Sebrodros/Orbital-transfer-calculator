%%Algorithm 4.1: To determine the orbital parameters of the transfer orbit.
%%Taken from Orbital Mechanics from Engineering students, 
%%Writen by Sebastian Rodriguez Rosero. 
%.........................................................................
function GetOrbitParaTransf(R,V, constant,units)

%Step 1 and 2
%Calculate the distance and speed.
[r, v]=getDistanceAndSpeed(R, V);
%Step 3,
%calculate the radial velocity. 
[vr]=getRadialVelocity(R,V,r);
%Step 4 and 5
%Calculate specific angular momentum. 
[H, h]=getSpecAngularMom(R, V);
 % Step 6
%Calculate the inclination.
i=getInclin(H, h);
%step 7 and 8
%Calculate the node line
[N, n]=getNodeLineVec(H);
%Step 8
%Calculate the Right Ascension of the ascending node.
RA=getRAAN(N, n);
%Step 10 and 11
%Calculate eccentricity vector and magnitude.
[E,e]=getEccent(constant,V,R,r,v,vr);
%step 12. 
%Calculate Argument of perigee.
w=getArgPeriapsis(N,E, n,e);

%step 13.
%Calculate the True anomaly.
TA=getTA(e,E,R,r, N, n, vr);

%% Display
fprintf('------------------------------------------\n')
fprintf(' \n Orbital Parameters of transfer orbit  \n')
fprintf('------------------------------------------\n')
fprintf('\n Eccentricity= %f \n Inclination= %f deg \n Right Ascension= %f deg \n Argument of Periapsis= %f deg \n ',e, i, RA, w);
fprintf('Angular Momentum= %f km^2/s \n True Anomaly= %f deg \n', h/(units.KM)^2, TA);
fprintf('------------------------------------------\n')

%% Functions
%Step 1 and 2
%Calculate the distance and speed. 
function [r, v]=getDistanceAndSpeed(R, V) 
    r=norm(R); 
    v=norm(V);
end
%Step 3, 
%calculate the radial velocity. 
function [vr,Towards]=getRadialVelocity(R,V,r)
    vr=dot(R,V)/r; 
        if vr>0 
           Towards='away';
        else 
           Towards='towards'; 
        end   
end
%Step 4 and 5
%Calculate specific angular momentum. m^2
function [H, h]=getSpecAngularMom(R, V)
H=cross(R,V);
h=norm(H);
end
% Step 6
%Calculate the inclination.
function i=getInclin(H, h)
i=zero_to_180(acosd(H(3)/h));
function y = zero_to_180(x)
if x >= 180
x = x - fix(x/180)*180;
elseif x < 0
x = x - (fix(x/180) - 1)*180;
end
y = x;
end

end
%step 7 and 8
%Calculate the node line
function [N, n]=getNodeLineVec(H)
K=[0,0,1];
N=cross(K,H);
n=norm(N);

end
%Step 9
%Calculate the Right Ascension of the ascending node.
function RA=getRAAN(N, n)
  if n ~= 0
    RA = zero_to_360(acosd(N(1)/n));
        if N(2) < 0
             RA = zero_to_360(2*pi - RA);
        end
  else
    RA = 0;
  end
end
%Step 10 and 11
%Calculate eccentricity vector and magnitude.
function [E,e]=getEccent(constant,V,R,r,v,vr)
E=1/constant.mu_sun*((v^2-constant.mu_sun/r)*R -r*vr*V);
e=norm(E);
end
%step 12. 
%Calculate Argument of perigee.
function w=getArgPeriapsis(N,E, n,e)
eps = 1.E-10;
    if n ~= 0
        if e > eps
            w = acosd(dot(N,E)/n/e);
                if E(3) < 0
                     w = 2*pi - w;
                end
        else
             w = 0;
        end
    else
         w = 0;
    end
end

%step 13.
%Calculate the True anomaly.
function TA=getTA(e,E,R,r, N, n, vr)
eps = 1.e-10;
if e > eps
    TA = zero_to_360(acosd(dot(E,R)/e/r));
    if vr < 0
            TA = zero_to_360(2*pi - TA);
    end
else
        cp = cross(N,R);
        if cp(3) >= 0
                TA = zero_to_360(acosd(dot(N,R)/n/r));
        else
                   TA = zero_to_360(2*pi - acosd(dot(N,R)/n/r));
        end
end
end

function y = zero_to_360(x)
if x >= 360
x = x - fix(x/360)*360;
elseif x < 0
x = x - (fix(x/360) - 1)*360;
end
y = x;
end
end