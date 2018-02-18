GenGOL
======

Generalized version of Conway's Game of Life (cellular automata) built in processing. 

 Keystroke commands: 
 * space - pick a new random rule set and randomize the world with the current 
           population density. 
 * c     - print the current settings. 
 * C     - print the current running cell population density. 
 * W,w   - reduce the population density by 10 or 1% and randomize the world. 
 * E,e   - increase the population density by 10 or 1% and randomize the world.
 * D,d   - Cycle through the demo rule sets. 
 * U,u   - reduce the rule density by 10 or 1%. 
 * I,i   - increase the rule density by 10 or 1%.
 * p     - pause/unpause 
 * r     - randomize the world.  
 * s     - step through paused world one iteration at a time. 
 * k,K   - increase or descrease the iterations skipped between display. Default is 0. 
           Range is 0-10. Can help determine period of some blinkers, etc. 
 * t     - Start with a single cell in the middle of the world. 
 * T     - Start with a 40x40 centered square randomized using population density.
 * x     - swap dead and live cell colors. 
 * !     - Enter debug mode. (After which mouse clicks report info.) 
 * z     - (Experimental) spawn new rules based on random rotations and mutation. 
