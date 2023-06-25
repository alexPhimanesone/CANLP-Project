/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Deliberative reasoning & Argumentation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*******************************************************************************
World processing
*******************************************************************************/ 


	/* 
	This module makes use of the domain knowledge to maintain
	the current state of the local world
	Note: This module doesn't know anything about necessities, preferences or abduction
	*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Propagating world states	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	/* Actual aspects of the world may be
	   - 'imposed' (if they belong to the initial state or result from actions)
	   - 'possible' (if they are actions that can be performed)
	   - 'inferred' (if they are consequences of other actual facts)
	   - 'decided' (if they are decisions)
	*/
	
	w_init_world :-
		retractall(situation(_,_)),
		% findall(T, (initial_situation(T), asserta(situation(T, imposed))), _),
		% findall(T, (incompatible([T]), opposite(T,T1), asserta(situation(T1, imposed))), _).
		true.
        
	w_state(F)	:- %adding a fact to the world
		assert(asserted(F)),
			tracer(2, [fact, F, 'added to the world']).
	
	w_state :-	retractall(asserted(_)).	% erasing added facts
	
	w_propagate :-
		% drawing inferences from known facts
			tracer(6, ['Inferring...']),
		consequence(_F, _),
		!,	% some new thing has been proven
		w_propagate.
	w_propagate.

	consequence(F,F1) :-
		w_supposed(F),
			tracer(6, [F, 'is supposed.']),
		% some forward chaining
		w_link(Causes, F1, _),	% considers material consequences of F
		select(F, Causes, Rest),
		w_probablyTrue(Rest),		% all elements in Rest are 'supposed'
		ground(F1), % too dangerous to store facts with variables
		not(status(F1,_)),	% F1 still unknown after instantiation
		w_memory(F, F1).	% F1 becomes possible, inferred or imposed, depending on the status of F

		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading the world	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	w_probablyTrue([F|Fl]) :-
		w_supposed(F),
		w_probablyTrue(Fl).
	w_probablyTrue([]).

	w_supposed(F) :-
		% F is supposed if it is known as imposed or inferred or decided
		status(F, Status),
		member(Status, [imposed, inferred, decided]).	% possible actions are not true
	w_supposed(F) :-
		% F is supposed if -F is unknown and F is logically possible and true by default
		default(F, _),
		not(incompatible([F])),	% F is not logically impossible
		opposite(F, NotF),
		not(status(NotF, _)).
	/*
	w_supposed(F) :-
		% F is supposed if -F is unknown and F is initially true
		initial_situation(F),
		opposite(F, NotF),
		not(situation(NotF, _)).
	*/

	status(F, S) :-
		situation(F, S).
	status(F, imposed) :-
		(initial_situation(F); asserted(F)),
		not(situation(F, _)), 	% negation after instantiation
		opposite(F, NotF),
		not(situation(NotF, _)).
	status(F, imposed) :-
		incompatible([T]), 
		opposite(T,F),
		not(situation(F, _)). 	% negation after instantiation
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Storing what happens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	w_memory(F, F1) :-
		w_clean(F1),
		action(F1),	% an action does not become true, just possible
		!,
		tracer(5,['inferring from', F, 'that',F1,'is possible']),
		asserta(situation(F1, possible)).
/*	w_memory(F, F1) :-
		action(F),	% the effect of actions are irreversible
		!,
		tracer(5,['inferring from', F, 'that',F1,'is definitely the case']),
		asserta(situation(F1,imposed)).
*/
	w_memory(F, F1) :-
		tracer(4,['inferring', F1, 'from', F]),
		asserta(situation(F1,inferred)).

	w_update :-
		% Revision of known facts
		% all previous deductions are erased (but 'imposed' situations remain)
		retractall(situation(_, inferred)),
		retractall(situation(_, possible)).
		
	% 'w_clean' destroys states that are about F or -F
	w_clean(-F) :-
		!,
		w_clean(F).
	w_clean(F) :-
		retractall(situation(F, _)),
		retractall(situation(-F, _)).
	/*
	w_clean(F) :-
		opposite(F, NF),
		member(F1, [F, NF]),
		retractall(situation(F1, _)),
		initial_situation(F1),
		asserta(situation(F1, imposed)),
		fail.
	w_clean(_).
	*/
		
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interface with knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	w_link(Causes, Effect, action) :-
		Effect <--- CauseChain,		% causal rules
		w_causal_to_list(CauseChain, Causes).
	w_link(Causes, Effect, causal) :-
		Effect <=== CauseChain,		% causal rules
		w_causal_to_list(CauseChain, Causes).
	w_link(Causes, Effect, logical) :-
		incompatible(IncompatibleSet),	% logical rules
		select(NEffect, IncompatibleSet, Causes),
		opposite(NEffect, Effect).

		
	w_causal_to_list(C1 + C2, CauseList) :-
		!,
		w_causal_to_list(C1, C1L),
		w_causal_to_list(C2, C2L),
		append(C1L, C2L, CauseList).
	w_causal_to_list(C, [C]).
		

%%%%%%%%%%%%%%%%%%%%%%%
% Execute actions
%%%%%%%%%%%%%%%%%%%%%%%
	w_make_it_so(F) :-
		w_revisable(F),
			tracer(5,['deciding', F]),
		w_update,		% forget inferences before rebuilding them
		w_clean(F),
		asserta(situation(F, decided)),
		talk(['------> Decision : ', F]),
		w_propagate,
			display_memory,
        	wait(3).



    w_possible(A) :-
		status(A, possible),
		!.
    w_possible(A) :-
		consequence(_,A).

	/*
	w_revisable(F) :-
		initial_situation(F),
		opposite(F, NotF),
		not(situation(NotF, _)),
		!,
		fail.		
	*/
	w_revisable(A) :-
		action(A),
		not(w_link(_, A, causal)),	% no prerequisites
		!,
			tracer(3,[A,'is revisable because it is an action with no prerequisite']).
	w_revisable(F) :-
		opposite(F, NF),
		member(F1, [F, NF]),
		status(F1,Status),
		member(Status, [imposed, inferred]),
		!,
			tracer(5,[F1,'is NOT revisable because it is ', Status]),
		fail.
	w_revisable(F) :-
		status(F,Status),
		!,
			tracer(3,[F,'is revisable because it is ', Status]).
	w_revisable(F) :-
			tracer(3,[F,'is revisable because its status is unknown']).
		
