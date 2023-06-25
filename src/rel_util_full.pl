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


:- dynamic(window_name/3).

tl(_).	% compatibility


authorised(Level) :-
	window_name(level, _, Indicator),
	get(Indicator,selection,Detail),
	Level =< Detail.

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
	write(' '),
	tracer(Level, R).
tracer(Level, [ ]) :-
	authorised(Level),
	!,
	nl.
tracer(_Level, _).

tracer(Level, abduct,[1,N,F]) :-
	N < 0,
	!,
	tracer(Level, ['Looking for weak reasons for',F, 'with strength',N]).
tracer(Level, abduct,[1,N,F]) :-
	tracer(Level, ['Looking for acts ensuring',   F, 'with strength',N]).
tracer(Level, abduct,[3,N,C1,N1]) :-
	N < 0,
	!,
	tracer(Level, ['tentative responsible term:',C1, '(',N1,')']).
tracer(Level, abduct,[3,_N,C1,N1]) :-
	tracer(Level, ['tentative suggestion:',      C1, '(',N1,')']).
tracer(Level, solve,[F,N1,N2]) :-
	tracer(Level, ['We have a conflict here :']),
	tracer(Level, ['\t',F, 'with necessity:', N1]),
	tracer(Level, ['\t',F, 'with necessity:', N2]),
	wait(Level).

error(Msg) :-
	nl,
	write('************'),nl,
	write('   error:   '), write(Msg),nl,
	write('************'),nl,
	fail.

talk([]) :-
	nl.
talk([Msg|R]) :-
	write(Msg),
	write(' '),
	talk(R).


highlight(F) :-
	necessity(F,N),
	!,
	display_active_want(F,N).
highlight(F) :-
	opposite(F,F1),
	necessity(F1,N),
	!,
	display_active_want(F1,N).
highlight(_F) :-
	error('highlight: inactive').

next_necessity(F, N) :-
	next_necessity(100, F, N).

next_necessity(Level, F, Level) :-
	strength(F, Level).
next_necessity(Level, F, N) :-
	Level > -100,
	Level1 is Level - 1,
	next_necessity(Level1, F, N).

display_memory :-
	display_rules,
	not(window_name(wants,_,_)),
	new(Disp1, dialog('Wish list')),
	send(Disp1, append, new(Wants, browser(size := size(42, 10))), below),
	%send(Disp1,width,430),
	new(Disp2, dialog('State of the world')),
	send(Disp2, append, new(Sits, browser(size := size(43, 15))), below),
	send(Sits, width, 133),
	send(Disp1, append, button('Refresh', 
			message(@prolog, display_memory)), below),
	send(Disp1, append, button('Dismiss', 
				message(@prolog,display_destroy)), right),
	send(Wants, style, inactive, 
			style(highlight := @off, font := large)),
	send(Wants, style, active, 
			style(highlight := @on, font := boldlarge)),
	send(Wants, style, extra, 
		style(colour := colour(red), font := boldlarge)),
	send(Wants, style, low, 
		style(colour := colour(blue), font := large)),
	send(Sits, style, inactive, 
		style(highlight := @off, font := large)),
	send(Sits, style, extra, style(colour := colour(red), 
				 font := boldlarge)),
	send(Sits, style, active, style(colour := colour(red), 
				font := boldlarge)),
	send(Disp2, append, new(P, int_item('Trace detail',
				low:=0, high:=6, default := 5)), below),
	asserta(window_name(level,Disp2,P)),
	send(Disp2, append, button('Refresh ', 
			message(@prolog,display_memory)), right),
	send(Disp2, append, button('Dismiss', 
				message(@prolog,display_destroy)), right),
	send(Disp1,open),
	send(Disp2,open),
	asserta(window_name(wants,Disp1,Wants)),
	asserta(window_name(sits,Disp2,Sits)),
	!,
	display_memory.
display_memory :-
	window_name(wants, _, Wants),
	window_name(sits, _, Sits),
	send(Wants,clear),
	send(Sits,clear),
	display_build_wants(FNList),
	send_list(Wants,append,FNList),
	findall(dict_item(T1, style := inactive),
		(situation(T,S), rule_to_atom(T == S,T1)),TSList),
	findall(T2, (conflicting(_, _, TT), situation(TT,SS), 
					rule_to_atom(TT == SS,T2)),TSList1),
	enhance_list(active, TSList1, TSList, TSList2),
	send_list(Sits,append,TSList2).

display_rules :-
	window_name(rules,_Disp,Rules),
	!,
	send(Rules, clear),
	findall(dict_item(F1, style := inactive),
		(F <=== C, rule_to_atom(F <=== C,F1)), RList),
	msort(RList, RList1),
	send_list(Rules, append, RList1).
display_rules :-
	new(Disp, dialog('Rules')),
	send(Disp, append, new(Rules, browser(size := size(75, 20))), below),
	send(Rules, style, inactive, style(font := large)),
	send(Rules, style, active, style(font := boldlarge, 
						colour := colour(blue))),
	send(Rules, style, extra, style(font := boldlarge,
						colour := colour(red))), 
	send(Disp, append, button('Dismiss', message(Disp,destroy)), below),
	send(Disp,open),
	asserta(window_name(rules,Disp,Rules)),
	display_rules.

display_build_wants(FNList4) :-
	findall(dict_item(F1, style := low),
		(next_necessity(F,N), rule_to_atom(F <--- N,F1)),FNList),
	findall(F2, (conflicting(FF, NN, _), 
					rule_to_atom(FF <--- NN,F2)),FNList1),
	enhance_list(extra, FNList1, FNList, FNList2),
	findall(F3, (unrealized(FFF, NNN), 
				rule_to_atom(FFF <--- NNN,F3)),FNList3),
	enhance_list(low, FNList3, FNList2, FNList4).

display_active_want(W,Nec) :-
	window_name(wants, _, Wants),
	send(Wants,clear),
	display_build_wants(FNList),
	rule_to_atom(W <--- Nec,FName),
	enhance(active, FName, FNList, FNList1),
	send_list(Wants,append,FNList1).

display_active_sit(Sit, Stat) :-
	window_name(sits, _, Sits),
	send(Sits,clear),
	findall(dict_item(T1, style := inactive),
		(situation(T,S), rule_to_atom(T == S,T1)),TSList),
	rule_to_atom(Sit == Stat,TName),
	enhance(active, TName, TSList, TSList1),
	send_list(Sits,append,TSList1).

display_active_rule(R) :-
	window_name(rules,_Disp,Rules),
	send(Rules,clear),
	findall(dict_item(F1, style := inactive),
		(F <=== C, rule_to_atom(F <=== C,F1)),RList),
	rule_to_atom(R, RName),
	enhance(active, RName, RList, RList1),
	msort(RList1,RList2),
	send_list(Rules,append,RList2).

/*------------------------------------------------*/
/* 'enhance' replaces an item in a browser list   */
/* to highlight it                                */
/*------------------------------------------------*/
enhance(Style, RName, [dict_item(RName, _) | RList], 
			[dict_item(RName, style := Style) | RList1]) :-
	!,
	enhance(Style, dummy, RList, RList1). 
enhance(Style, R, [RName | RList], [RName | RList1]) :- 
	enhance(Style, R, RList, RList1). 
enhance(_Style, dummy, [], []) :-
	!.
enhance(_Style, R, [], [dict_item(R, style := extra) ]).

/*------------------------------------------------*/
/* 'enhance_list' replaces items present          */
/* in the first list to highlight them in the 2nd */
/*------------------------------------------------*/
enhance_list(_Style, [ ], Listin, Listin).
enhance_list(Style, [Item | ItmList], Listin, Listout) :-
	enhance(Style, Item, Listin, Listin1),
	enhance_list(Style, ItmList, Listin1, Listout).

	
/*------------------------------------------------*/
/* 'rule_to_atom builds' textual representations  */
/* of compound terms                              */
/*------------------------------------------------*/
rule_to_atom(T, T1) :-
	rule_to_atom(T, T1, [], _VarList).	% for processing of variables

% The variable list is used to store names like X,Y,Z... assigned to variables
rule_to_atom(T, VName, VarList, VarList) :-
	var(T),
	term_to_atom(T, T1),
	member((T1,VName),VarList),
	!.
rule_to_atom(T, VName1, [(T2,VName2)|VR],[(T1,VName1), (T2,VName2)|VR]) :-
	var(T),
	term_to_atom(T, T1),
	!,
	char_code(VName2,C2),
	% the next formula gives the series X Y Z U V W
	C1 is C2 + 1 - (1 + sign(C2-90) + (1 - abs(sign(C2-90)))) * 3,
	char_code(VName1,C1).
rule_to_atom(T, 'X', [ ],[(T1,'X')]) :-
	var(T),
	!,
	term_to_atom(T, T1).
rule_to_atom([], '', VL, VL) :-
	!.
rule_to_atom([T|TL], TL2, VL, VL2) :-
	!,
	rule_to_atom(T, T1, VL, VL1),
	rule_to_atom(TL, TL1, VL1, VL2),
	atom_concat(T1,' ',T2),
	atom_concat(T2,TL1,TL2).
rule_to_atom(T, T1, VL, VL1) :-
	T =.. [Fonct | Args],
	not(Args = [ ]),
	!,
	beautiful(Fonct, Args, T1, VL, VL1).
rule_to_atom(T, T1, VL, VL) :-
	term_to_atom(T, T1).

/*------------------------------------------------*/
/* 'beautiful' processes functional terms         */
/*                                                */
/*------------------------------------------------*/
beautiful(F, [T|Q], Result, VL, VL2) :-
	member(F,['<===','+','///','==','<---']),
	!,
	rule_to_atom(T, T1, VL, VL1),
	rule_to_atom(Q, Q1, VL1, VL2),
	atom_concat(T1,' ',T2),
	atom_concat(T2,F,T3),
	atom_concat(T3,' ',T4),
	atom_concat(T4,Q1,Result).
beautiful('-', Args, T, VL, VL1) :-
	!,
	rule_to_atom(Args, Arg1, VL, VL1),
	atom_concat('-', Arg1,T).
beautiful(F, Args, T, VL, VL1) :-
	rule_to_atom(Args, Args1, VL, VL1),
	atom_concat(F,'[ ',T1),
	atom_concat(T1,Args1,T2),
	atom_concat(T2,']',T).

display_destroy :-
	retract(window_name(wants, D1, _)),
	retract(window_name(sits, D2, _)),
	retract(window_name(rules,D3,_)),
	retractall(window_name(_,_,_)),
	send(D1,destroy),
	send(D2,destroy),
	send(D3,destroy).
