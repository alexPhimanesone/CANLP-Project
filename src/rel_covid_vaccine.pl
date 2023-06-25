action(arn_vaccine).
action(vaccine).
action(viral_vector_with_ADN_vaccine).
action(viral_vector_with_proteine_vaccine).
action(attenuated_vaccine).

preference(genome_modified_risk, -50).
preference(covid_sick, -20).
preference(secondary_effect, -30).
preference(after_effect, -40) 
preference(contagion_risk, -40).
preference(social_contact, 30).
belief(barrier_gestures, 30).
belief(natural_resistance, -10).

default(-immunity).
default(-covid_sick).

# initial_situation(-covid_sick).
# initial_situation(secondary_effect).
# initial_situation(contagion_risk).
initial_situation(after_effect).

incompatible(immunity, covid_sick) 
incompatible(natural_resistance, covid_sick).
incompatible(vaccine, -arn_vaccine, -viral_vector_with_ADN_vaccine, -viral_vector_with_proteine_vaccine, -attenuated_vaccine).
incompatible(arn_vaccine, -replication_in_cytoplasm).
incompatible(replication_in_cytoplasm, genome_modified_risk).
incompatible(phase3_test, after_effect).
incompatible(arn_vaccine, -available).
incompatible(viral_vector_with_proteine_vaccine, available).
incompatible(viral_vector_with_ADN_vaccine, -	available).
incompatible(attenuated_vaccine, accredited).  # non homologué en France
incompatible(antibody_produced, -natural_resistance).
incompatible(-social_contact, good_mental_health).

covid_sick <=== -barrier_gestures + social_contact + contagion_risk.
immunity <=== vaccine + antibody_produced.
after_effect <=== covid_sick + genetic_predisposition.

