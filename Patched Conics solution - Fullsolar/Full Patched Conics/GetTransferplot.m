%this function simulates the orbits of the planets around the sun and it
%displays a graph with the transfer orbit betwen Earth and Mars. 
%Code made by Sebastian Rodriguez Rosero. 
%Summer 2020. 
%UPDATED ON: 12/2/2020
%THIS NEEDS TO BE UPDATED. CURRENTLY ONLY WORKS FOR EARTH-MARS TRANSFERS. 
%REASONS WHY:
    %  dt is fixed but in order to work for all planets need to change. 
    %  the N number of iterations should also be able to change depending on which planets are selected. 
    %  Not exactly sure whether this also works for retrograde orbits. 
    %  Everything needs further validation against other models out there.
    
    
    % Test values for position and velocity of planets.
    %{
  
planet1='Earth'; planet2='Mars';
% loading up constants and unit conversion factors.
[units,constant]=unitsandconstants();
% Initial Parameteres.
% choose the planets for the patched conics. 
[planetdatadeparture]=setPlanetDatabase(planet1);
[planetdataarrival]=setPlanetDatabase(planet2);

InitialPosE=[-5.014736309564022e+10;1.383061599202025e+11;-5.564504134811053e+06];
InitialPosM=[1.757966029689569e+11;-1.087183099762519e+11;-6.595672020921984e+09];

InitialVelE=[-2.848960191060742e+04;-1.026609696481579e+04;0.719157763561215];
InitialVelM= [1.366707595265878e+04;2.268076511288485e+04;1.397362516901796e+02];

TransferVel=[-2.559110936596208e+04;-1.973910298786801e+04;1.585657651785560e+03]; 


SGetTransferplot(InitialPosE, InitialVelE, InitialPosM, InitialVelM,TransferVel,constant,units,planet1,planet2,planetdataarrival, planetdatadeparture)
%}   
%%   
function GetTransferplot(InitialPosE, InitialVelE, InitialPosM, InitialVelM,TransferVel,constant,units,planet1,planet2,planetdataarrival, planetdatadeparture)

TransferPos=InitialPosE; %m
TransferFinalPos=InitialPosM; %m
dt=3600*24;
N=1000000;

%% plot
%-------------------------------------
figure ('name','Interplanetary transfer')
hold on
axis equal
grid on
grid minor 

xlabel('X(AU)','FontName','Times');
ylabel('Y(AU)','FontName','Times');
zlabel('Z(AU)','FontName','Times');

%% This section fixes the plot depending on the chosen planets. 
if planetdatadeparture.aAU>planetdataarrival.aAU
    half=planetdatadeparture.aAU/2;
    xlim([-planetdatadeparture.aAU-half planetdatadeparture.aAU+half])
    ylim([-planetdatadeparture.aAU-half planetdatadeparture.aAU+half])
    zlim([-1 1])

elseif planetdataarrival.aAU>planetdatadeparture.aAU
    half=planetdataarrival.aAU/2;
    xlim([-planetdataarrival.aAU-half planetdataarrival.aAU+half])
    ylim([-planetdataarrival.aAU-half planetdataarrival.aAU+half])
    zlim([-1 1])
end

%% 
legend('location','northeast','FontName','Times')
%------------------------------
% plot sun
plot3(0,0,0, 'hy', 'MarkerSize', 10,'DisplayName','Sun');


plot3(TransferPos(1)/units.AU,TransferPos(2)/units.AU,TransferPos(3)/units.AU, 'o','MarkerSize', 5,'color',planetdatadeparture.color,'DisplayName',planet1)

plot3(TransferFinalPos(1)/units.AU,TransferFinalPos(2)/units.AU,TransferFinalPos(3)/units.AU, 'o','MarkerSize', 5,'color',planetdataarrival.color,'DisplayName',planet2)

%Plot planets' orbits
%planet1
[posE]=positiontracer(InitialPosE, InitialVelE, dt, N, constant);
h1=plot3(posE(:,1)/units.AU,posE(:,2)/units.AU,posE(:,3)/units.AU,'color',planetdatadeparture.color,'linestyle','--');
%planet2
[posM]=positiontracer(InitialPosM, InitialVelM, dt, N, constant);
h2=plot3(posM(:,1)/units.AU,posM(:,2)/units.AU,posM(:,3)/units.AU,'color',planetdataarrival.color,'linestyle','--');
%plot transfer orbit. 
[pos]=positiontracerTRANS(TransferPos, TransferVel,TransferFinalPos, dt, N, constant);
plot3(pos(:,1)/units.AU,pos(:,2)/units.AU,pos(:,3)/units.AU,'--','DisplayName','Spacecraft')

set(get(get(h1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(h2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

%-------------------------------
%% Functions
%displays the planetary orbits. 

function [pos]=positiontracer(InitialPos, InitialVel, dt, N, constant) 


%Initial Conditions

rx=InitialPos(1);
ry=InitialPos(2);
rz=InitialPos(3);                       %initial position.
Vx=InitialVel(1);                       %Velocity in the x direction. m/s
Vy=InitialVel(2);                       %Velocity in the y direction. m/s
Vz=InitialVel(3);


initialPosCheck=[rx ry rz];             %Saves a copy of the initial position.
%%
R = zeros(N,3);
V = zeros(N,3);
dvdt = zeros(N,3);
t=zeros(N,1);


Check=false;
%Initial Conditions of vectors
        R(1,:) =[rx ry rz];
        V(1,:) = [Vx Vy Vz];
        Sun = [0 0 0];

%% Solution
%--------------------------

 for i=1:N
        
        [G_dV] = getGdV(Sun,R(i,:),constant);
        dvdt(i,:)=G_dV;
     
  if i<N
      V(i+1,:)= V(i,:)+dvdt(i,:)*dt;
      R(i+1,:)= R(i,:)+V(i+1,:)*dt;
      t(i+1)=t(i)+dt;
  end 
  
  if Check==true
      if R(i,:)==initialPosCheck
          R(i:N,:) = [];
          break
          
      end
  end
  
  Check=true;
 end
 pos=R;

   
end

%displays the transfer orbits. 
function [pos]=positiontracerTRANS(TransferPos, TransferVel,TransferFinalPos, dt, N, constant)

%Initial Conditions
rx=TransferPos(1);
ry=TransferPos(2);
rz=TransferPos(3);            %initial position.
Vx=TransferVel(1);          %Velocity in the x direction. m/s
Vy=TransferVel(2);            %Velocity in the y direction. m/s
Vz=TransferVel(3);
%%
R = zeros(N,3);
V = zeros(N,3);
dvdt = zeros(N,3);
t=zeros(N,1);
%Initial Conditions of vectors
        R(1,:) =[rx ry rz];
        V(1,:) = [Vx Vy Vz];
        Sun = [0 0 0];

%% Solution
%---------------------------

 for i=1:N
        
        [G_dV] = getGdV(Sun,R(i,:),constant);
        dvdt(i,:)=G_dV;
     
  if i<N
      V(i+1,:)= V(i,:)+dvdt(i,:)*dt;
      R(i+1,:)= R(i,:)+V(i+1,:)*dt;
      t(i+1)=t(i)+dt;
  end
       h=norm(R(i,:));
       
       if h>norm(TransferFinalPos)
            R(i:N,:) = [];
           break 
       end
 end
 pos=R;


end

%Gravitational force due to the sun. 
function [G_dV] = getGdV(Planet,Pos,constant)
    
    ToPlanet = (Planet-Pos);
    G_unit = ToPlanet./norm(ToPlanet);
    G_mag = constant.mu_sun/norm(Pos)^2;
    G_dV = G_mag.*G_unit;
    
end

end