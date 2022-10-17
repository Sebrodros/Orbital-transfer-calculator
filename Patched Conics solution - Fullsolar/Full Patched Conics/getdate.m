function [monthD, dayD, yearD] = getdate


for itry = 1:1:5
    
    fprintf('\nplease input the calendar date');
    fprintf('\n(1 <= month <= 12, 1 <= day <= 31, year = all digits!)\n');
    cdstr = input('? ', 's');
    tl = size(cdstr);
    ci = strfind(cdstr, ',');

    % extract month, day and year

    monthD = str2double(cdstr(1:ci(1)-1));
    dayD = str2double(cdstr(ci(1)+1:ci(2)-1));
    yearD = str2double(cdstr(ci(2)+1:tl(2)));

    % check for valid inputs
    if (monthD >= 1 && monthD <= 12 && dayD >= 1 && dayD <= 31)
        break; 
    end
    fprintf('Oops! \nInvalid input, try again :)') 
end