%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Deliberative reasoning & Argumentation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*-------------------------------------------------|
|* Domain knowledge for CAN                       *|
|*------------------------------------------------*/

	/*
	Pay attention to the fact that the following lines are not Prolog clauses, but will be interpreted by the program. 
	The only Prolog predicates are:
   - initial_situation
   - action
   - default
   - preference
   -  <===	(physical effects)
	 */ 

	% default predicates: these predicates are true unless proven false
    % defaults values may represent the strength, or typicality, of the default
	default(-short(1), 7).

	% initial situation
	initial_situation(-have_izly).
	:- dynamic initial_situation/1.

	% actions
	action(franprix).
	action(wan).
	action(food_asia).
	action(crous).
	action(le19).

	% causal clauses
	-hungry(1) <=== food_asia.
	-hungry(2) <=== food_asia.
	spend(3)   <=== food_asia.
	good(2)    <=== food_asia.
	too_long   <=== food_asia + short(1).
	-hungry(1) <=== crous + have_izly.
	-hungry(2) <=== crous + have_izly.
	spend(1)   <=== crous + have_izly.
	good(2)    <=== crous + have_izly.
	-long      <=== crous + have_izly.
	-hungry(1) <=== wan.
	-hungry(2) <=== wan.
	-hungry(3) <=== wan.
	spend(2)   <=== wan.
	good(2)    <=== wan.
	-long      <=== wan.
	-hungry(1) <=== franprix.
	spend(2)   <=== franprix.
	good(1)    <=== franprix.
	-long      <=== franprix.
	-hungry(1) <=== le19.
	-hungry(2) <=== le19.
	spend(3)   <=== le19.
	good(3)    <=== le19.
	too_long   <=== le19 + short(1).

	% preferences (positive predicates only)
	preference(hungry(1), -7 ).
	preference(hungry(2), -10).
	preference(hungry(3), -13).
	preference(spend(1),  -4 ).
	preference(spend(2),  -6 ).
	preference(spend(3),  -8 ).
	preference(good(1),   -5 ).
	preference(good(2),   -3 ).
	preference(good(3),   -0 ).
	preference(too_long,  -9 ).
