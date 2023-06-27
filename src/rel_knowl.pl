/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Deliberative reasoning & Argumentation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                           
/*******************************************************************************
Interface with the domain knowledge
******************************************************************************* 



	- The domain knowledge is imbedded in 'causal clauses':
	Effect <=== Cause1 + Cause2 + ... 
	- The domain knowledge may contain 'negative clauses' (incompatibilities):
	incompatible([T1, T2 ...]). 
	- The domain knowledge also contains explicit preferences:
	preference(Fact, Intensity).
	- The domain knowledge involves initial facts:
	initial_situation(F).
	- The domain knowledge makes the distinction between actions and facts
	action(A).
	- The domain knowledge may contain default predicates
	default(P, Typicality).

                                                                              */

	/*------------------------------------------------*/
	/* Initialisations                                */
	/*------------------------------------------------*/
	% the following lines make the corresponding predicates optional in the knowledge base
	:- dynamic(situation/2).	% current knowledge about the situation
	:- dynamic(prefer/2).	% current preferences
	:- dynamic( <--- /2).	% effect-action links
	:- dynamic( <=== /2).	% effect-causes links
	:- dynamic(incompatible /1).	% logical rules
	:- dynamic(default /2).	% default rules
	:- dynamic(action /1).	% actions
	:- dynamic(asserted /1).	% user asserted facts

	:- op(950, xfy, <===).	% 'is caused by', physical causes
	:- op(950, xfy, <---).	% 'is caused by', actions  
	:- op(500, xfy, +).	% 'and'
	:- op(400, fy, -).	% 'not'



	/*------------------------------------------------*/
	/* Domain knowledge starts here                   */
	/*------------------------------------------------*/

	:- consult('rel_lunch.pl').
	% :- consult('rel_doors.pl').
	% :- consult('rel_portes.pl').
	% :- consult('energy.pl').
	% :- consult('rel_projector.pl').
	% :- consult('rel_pollock.pl').

