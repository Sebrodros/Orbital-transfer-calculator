function JDD=getJulian(dates)
Jo=367*dates.year-floor(((7*(dates.year+floor((dates.month+9)/12))/4)))+floor(275*dates.month/9)+dates.day+1721013.5;
UT=0; %in hours. Universal time.
JDD=Jo+UT/24; %days
end
