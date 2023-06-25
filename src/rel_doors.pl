/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  Deliberative reasoning & Argumentation %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*-------------------------------------------------|
|* Domain knowledge for CAN                       *|
|* Dialogue: 'doors'                              *|
|*-------------------------------------------------/

	Original dialogue:
	==================
[Contexte: A repeint ses portes. Il a décidé de décaper l'ancienne peinture, ce qui se révèle pénible.]

A1- Ben moi, j'en bave actuellement parce qu'il faut que je refasse mes portes, la peinture.
    Alors j'ai décapé à la chaleur. Ca part bien. Mais pas partout. C'est un travail dingue, hein?
B- heu, tu as essayé de. Tu as décapé tes portes?
A1a- Ouais, ça part très bien à la chaleur, mais dans les coins, tout, les moulures, c'est infaisable. [plus fort] Les moulures.
B - Quelle chaleur? La lampe à souder?
A- Ouais, avec un truc spécial.
B1- Faut une brosse, dure, une brosse métallique.
A2- Oui, mais j'attaque le bois.
B2- T'attaques le bois.
A3- [pause 5 secondes] Enfin je sais pas. C'est un boulot dingue, hein?
    C'est plus de boulot que de racheter une porte, hein?
B3- Oh, c'est pour ça qu'il vaut mieux laiss... il vaut mieux simplement poncer, repeindre par dessus
A4- Ben oui, mais si on est les quinzièmes à se dire ça
B4- Ah oui.
A5- Y a déjà trois couches de peinture, hein, dessus.
B5- Remarque, si elle tient bien, la peinture, là où elle est écaillée, on peut enduire. De l'enduit à l'eau, ou
A6- Oui, mais l'état de surface est pas joli, quoi, ça fait laque, tu sais, ça fait vieille porte.

	English translation:
	===================
A1-  I have to repaint my doors. I've burned off the old paint. It worked OK, but not everywhere. It's really tough work! [...] In the corners, all this, the mouldings, it's not feasible !
[...]
B1- You have to use a wire brush   
A2- Yes, but that wrecks the wood   
B2- It wrecks the wood...   
[pause 5 seconds]
A3- It's crazy! It's more trouble than buying a new door.
B3- Oh, that's why you'd do better just sanding and repainting them.   
A4- Yes, but if we are the fifteenth ones to think of that   
B4- Oh, yeah...   
A5- There are already three layers of paint   
B5- If the old remaining paint sticks well, you can fill in the peeled spots with filler compound   
A6- Yeah, but the surface won't look great. It'll look like an old door.

	Content to reconstruct:
	=======================
A1- repaint, burn-off, mouldings, tough work
B1- wire brush
A2- wood wrecked
A3- tough work
B3- sanding
A5- several layers
B5- filler compound
A6- not nice surface
                                                                              */


	/*------------------------------------------------*/
	/* Domain knowledge starts here                   */
	/*------------------------------------------------*/

	/* pay attention to the fact that the following
	   lines are not Prolog clauses, but will be interpreted
	   by the program. 
	   The only Prolog predicates are:
	   - initial_situation
	   - action
	   - default
	   - preference
	   - incompatible
	   -  <===	(physical effects)
	   -  <---	(results of actions)-	(not used)
	 */ 

	% initial facts
	initial_situation(-nice_doors).
	initial_situation(-nice_surface).
	initial_situation(mouldings).
	initial_situation(soft_wood).
	initial_situation(several_layers).
	


	% actions
	action(repaint).
	action(burn_off).
	action(wire_brush).
	action(sanding).
	action(filler_compound).

	
	% default predicates: these predicates are true unless proven false
	% defaults values (not used here) may represent the strength, or typicality, of the default
	default(-soft_wood, _).	
	default(-several_layers, _).
	default(-wire_brush, _).
	default(-wood_wrecked, _).	


	% causal clauses
	nice_surface <=== filler_compound + -wood_wrecked.
	nice_surface <=== burn_off + -wood_wrecked.
	nice_surface <=== sanding + -several_layers + -wood_wrecked.
	nice_doors <=== repaint + nice_surface.
	wood_wrecked  <=== wire_brush + soft_wood.

	
	% physical consequences
	tough_work <=== burn_off + mouldings + -wire_brush.
	-nice_surface <=== wood_wrecked.


	% preferences (positive predicates only)
	preference(tough_work, -10).
	preference(nice_doors, 20).
