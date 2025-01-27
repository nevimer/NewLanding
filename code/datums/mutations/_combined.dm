/datum/generecipe
	var/required = "" //it hurts so bad but initial is not compatible with lists
	var/result = null

/proc/get_mixed_mutation(mutation1, mutation2)
	if(!mutation1 || !mutation2)
		return FALSE
	if(mutation1 == mutation2) //this could otherwise be bad
		return FALSE
	for(var/A in GLOB.mutation_recipes)
		if(findtext(A, "[mutation1]") && findtext(A, "[mutation2]"))
			return GLOB.mutation_recipes[A]

/* RECIPES */

/datum/generecipe/hulk
	required = "/datum/mutation/human/strong; /datum/mutation/human/radioactive"
	result = HULK

/datum/generecipe/shock
	required = "/datum/mutation/human/insulated; /datum/mutation/human/radioactive"
	result = SHOCKTOUCH

/datum/generecipe/tonguechem
	required = "/datum/mutation/human/tongue_spike; /datum/mutation/human/stimmed"
	result = TONGUESPIKECHEM

/datum/generecipe/martyrdom
	required = "/datum/mutation/human/strong; /datum/mutation/human/stimmed"
	result = MARTYRDOM
