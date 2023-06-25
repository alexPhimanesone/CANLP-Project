/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Deliberative reasoning & Argumentation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*******************************************************************************
Module utilitaire
*******************************************************************************/ 

:- dynamic(trace_level/1).

tl(TL) :-
	retractall(trace_level(_)),
	assert(trace_level(TL)).


authorised(Level) :-
	trace_level(TL),
	Level =< TL.

wait(Level) :-
	authorised(Level),
	% get0(C), C == 'q'.
	get_single_char(C), member(C, [27, 113]),	% type 'q' or Esc for quitting
	!,
	abort.
wait(_).

tracer(Level, [Msg|R]) :-
	authorised(Level),
	!,
	write(' '),
	write(Msg),
	tracer(Level, R).
tracer(Level, [ ]) :-
	authorised(Level),
	!,
	nl.
tracer(_Level, _).

talk(L) :-
	tracer(1,L).

display_memory.	% compatibility

display_active_sit(_, _).	% compatibility