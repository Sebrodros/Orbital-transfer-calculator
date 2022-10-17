function JDD=getJulian(year,month,day)
Jo=367*year-floor(((7*(year+floor((month+9)/12))/4)))+floor(275*month/9)+day+1721013.5;
UT=0; %in hours. Universal time.
JDD=Jo+UT/24; %days
end
