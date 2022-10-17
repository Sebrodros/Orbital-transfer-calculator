function [date]=choosedates()
while(1)  
fprintf('\nWould you like to put a specific time of launch/arrival?(y/n). (If not, default to 0 UTC)\n')
   slct15 = input('? ', 's');
   if (slct15 == 'y' || slct15 == 'n')
      break;
   end 
   fprintf('Oops! \nInvalid input, try again :)') 
end
timechoice=slct15;

if timechoice=='y'
fprintf('DEPARTURE DATE: ')
      [date.monthD, date.dayD, date.yearD] = getdate;
      [date.hourD] = gettime; 
fprintf('Chosen date: %.0f/%.0f/%.0f\n',date.monthD, date.dayD, date.yearD)

%Input date of Arrival:
fprintf('ARRIVAL DATE: ')
       [date.monthA, date.dayA, date.yearA] = getdate;
       [date.hourA] = gettime; 
fprintf('Chosen date: %.0f/%.0f/%.0f\n',date.monthD, date.dayD, date.yearD)

else
    fprintf('DEPARTURE DATE: ')
     [date.monthD, date.dayD, date.yearD] = getdate; 
     fprintf('Chosen date: %.0f/%.0f/%.0f\n',round(date.monthD,0),round( date.dayD,0), round(date.yearD,0));
    fprintf('ARRIVAL DATE: ')
     [date.monthA, date.dayA, date.yearA] = getdate;
     date.hourD=0; date.hourA=0; 
     fprintf('Chosen date: %.0f/%.0f/%.0f\n',round(date.monthA,0),round( date.dayA,0), round(date.yearA,0));

end
end