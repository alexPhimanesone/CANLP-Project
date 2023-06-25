	language('English').
	
	% initial_situation(-moustache).
	% initial_situation(-jones).
	% initial_situation(-eye).
	% initial_situation(-paul).
	% initial_situation(-jacob).
	initial_situation(_) :- 
		% wait(2),
		fail.

	% defaults
	default(jones, 30).
	default(paul, 30).
	default(jacob, 30).	

	% causal clauses
	% moustache <=== jones.
	% -moustache <=== -jones.
	% -eye <=== paul + -jacob.
	% -jones <=== -eye.
	% eye <=== jacob + -paul.

	incompatible([moustache, -jones]).
	incompatible([-moustache, jones]).
	incompatible([paul, eye]).
	incompatible([jones, -eye]).
	incompatible([jacob, -eye]).
	
	% preferences (termes positifs seulement)
	preference(moustache, 20).
	% asserted(-jacob).