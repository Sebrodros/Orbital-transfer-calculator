function [date1,date2]=choosedates()
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
      [date1.month, date.day, date.year] = getdate;
      [date1.hour] = gettime; 
%Input date of Arrival:
fprintf('ARRIVAL DATE: ')
       [date2.month, date.day, date.year] = getdate;
       [date2.hour] = gettime; 
else
    fprintf('DEPARTURE DATE: ')
     [date1.month, date1.day, date1.year] = getdate; 
    fprintf('ARRIVAL DATE: ')
     [date2.month, date2.day, date2.year] = getdate;
     date1.hour=0; date2.hour=0; 
end
end