# Mars-and-back-2022

This code does the orbital mechanics for the earth to Mars mission. 

FOLDERS:
1.Orbital calcs: Has the saved figures for porkchop plots. 
2. Patched Conics Solution - Fullsolar: The main file is called patchedconics. Just run it and follow the prompts. 
This code was validated with other solvers and the perseverance 2022 mission. In general, say no to the question about specifying time. 
Currently the orbital plotter only works for earth-mars (don't have time to fix for others). 
3. PorkChop: The main codes are the ones that start with Porky. 
  for this code you specify the dates and dt. In the plotting part, you can change the limit for the countours and the resolution. For both the velocity contours and the TOF. 
  Right now I have it setup so that the return date is N months after than the launch. 
      1.Porky_EtoM...: Earth to Mars mission.s
      2. Porky_MtoE...: Mars to earth missions. 
      3. DV is for delta V to specified altitute. 
         Vinf is for hyperbolic excess velocity. 
