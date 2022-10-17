function [chooseproretro]=chooseproretro()
    while(1)
    fprintf('\nPlease choose either a prograde or retrograde trajectory. prograde="p" retrograde="r" \n')
       slct = input('? ', 's');
       if (slct == 'r' || slct == 'p')
          break;
       end 
       fprintf('Oops! \nInvalid input, try again :)') 
    end
    if slct=='r'
        chooseproretro='retro';
    else
        chooseproretro='pro';
    end
end