%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Deliberative reasoning & Argumentation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*-------------------------------------------------|
|* Domain knowledge for CAN                       *|
|*------------------------------------------------*/


/*
	Dialogue:
	=========

	Content to reconstruct:
	=======================

*/                                                                            


	/*
	pay attention to the fact that the following lines are not Prolog clauses, but will be interpreted by the program. 
	The only Prolog predicates are:
   - initial_situation
   - action
   - default
   - preference
   - incompatible
   -  <===	(physical effects)
   -  <---	(results of actions)
	 */ 

	/*
	List of options:
	- Franprix
	- WAN
	- Crous
	- Food Asia
	*/

	% default predicates: these predicates are true unless proven false
    % defaults values may represent the strength, or typicality, of the default
	default(have_izly, 10)

	% incompatibility rules

	% physical consequences / prerequisites
	have_izly <=== crous.

	% initial situation
	initial_situation(hungry).

	% actions
	action(franprix).
	action(wan).
	action(crous).
	action(food_asia).
	action(le19).

	% causal clauses
	-hungry1 <=== wan.
	-hungry2 <=== wan.
	-hungry3 <=== wan.
	spend2   <=== wan.
	good2    <=== wan
	quick    <=== wan.
	-hungry1 <=== franprix
	spend2   <=== franprix
	good1    <=== franprix
	quick    <=== franprix
	-hungry1 <=== le19.
	-hungry2 <=== le19.
	spend3   <=== le19.
	good3    <=== le19.
	-hungry1 <=== food_asia.
	-hungry2 <=== food_asia.
	spend3   <=== food_asia.
	good2    <=== food_asia.
	-hungry1 <=== crous.
	-hungry2 <=== crous.
	spend1   <=== crous.
	good2    <=== crous.
	quick    <=== crous.

	% preferences (positive predicates only)
	preference(hungry1,   -7 ).
	preference(hungry2,   -10).
	preference(hungry3,   -13).
	preference(spend1,    -3 ).
	preference(spend2,    -5 ).
	preference(spend3,    -7 ).
	preference(good1,      3 ).
	preference(good2,      5 ).
	preference(good3,      7 ).
	preference(quick,      5 ).
