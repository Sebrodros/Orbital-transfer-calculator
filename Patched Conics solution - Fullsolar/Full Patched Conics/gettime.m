function [hour] = gettime

% interactive request and input of universal time


for itry = 1:1:5
    fprintf('\nplease input the universal time');

    fprintf('\n(0 <= hours <= 24, 0 <= minutes <= 60, 0 <= seconds <= 60)\n');

    utstr = input('? ', 's');

    tl = size(utstr);

    ci = strfind(utstr, ',');

    % extract hours, minutes and seconds

    uthr = str2double(utstr(1:ci(1)-1));

    utmin = str2double(utstr(ci(1)+1:ci(2)-1));

    utsec = str2double(utstr(ci(2)+1:tl(2)));

    % check for valid inputs

    if (uthr >= 0 && uthr <= 24 && utmin >= 0 && utmin <= 60 ...
            && utsec >= 0 && utsec <= 60)
        hour=uthr+utmin/60+utsec/3600;
        break;
    end
end