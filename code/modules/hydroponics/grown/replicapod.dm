// A very special plant, deserving it's own file.

/obj/item/seeds/replicapod
	name = "pack of replica pod seeds"
	desc = "These seeds grow into replica pods. They say these are used to harvest humans."
	icon_state = "seed-replicapod"
	species = "replicapod"
	plantname = "Replica Pod"
	product = /mob/living/carbon/human //verrry special -- Urist
	lifespan = 50
	endurance = 8
	maturation = 10
	production = 1
	yield = 1 //seeds if there isn't a dna inside
	potency = 30
	var/volume = 5
	var/ckey
	var/realName
	var/datum/mind/mind
	var/blood_gender
	var/blood_type
	var/list/features
	var/factions
	var/list/quirks
	var/sampleDNA
	var/contains_sample = FALSE
	var/being_harvested = FALSE

/obj/item/seeds/replicapod/Initialize()
	. = ..()

	create_reagents(volume, INJECTABLE|DRAWABLE)

/obj/item/seeds/replicapod/create_reagents(max_vol, flags)
	. = ..()
	RegisterSignal(reagents, list(COMSIG_REAGENTS_ADD_REAGENT, COMSIG_REAGENTS_NEW_REAGENT), .proc/on_reagent_add)
	RegisterSignal(reagents, COMSIG_REAGENTS_DEL_REAGENT, .proc/on_reagent_del)
	RegisterSignal(reagents, COMSIG_PARENT_QDELETING, .proc/on_reagents_del)

/// Handles the seeds' reagents datum getting deleted.
/obj/item/seeds/replicapod/proc/on_reagents_del(datum/reagents/reagents)
	SIGNAL_HANDLER
	UnregisterSignal(reagents, list(COMSIG_REAGENTS_ADD_REAGENT, COMSIG_REAGENTS_NEW_REAGENT, COMSIG_REAGENTS_DEL_REAGENT, COMSIG_PARENT_QDELETING))
	return NONE

/// Handles reagents getting added to this seed.
/obj/item/seeds/replicapod/proc/on_reagent_add(datum/reagents/reagents)
	SIGNAL_HANDLER
	var/datum/reagent/blood/B = reagents.has_reagent(/datum/reagent/blood)
	if(!B)
		return

	if(B.data["mind"] && B.data["cloneable"])
		mind = B.data["mind"]
		ckey = B.data["ckey"]
		realName = B.data["real_name"]
		blood_gender = B.data["gender"]
		blood_type = B.data["blood_type"]
		features = B.data["features"]
		factions = B.data["factions"]
		quirks = B.data["quirks"]
		sampleDNA = B.data["blood_DNA"]
		contains_sample = TRUE
		visible_message(SPAN_NOTICE("The [src] is injected with a fresh blood sample."))
		log_cloning("[key_name(mind)]'s cloning record was added to [src] at [AREACOORD(src)].")
	else
		visible_message(SPAN_WARNING("The [src] rejects the sample!"))
	return NONE

/// Handles reagents being deleted from these seeds.
/obj/item/seeds/replicapod/proc/on_reagent_del(changetype)
	SIGNAL_HANDLER
	if(reagents.has_reagent(/datum/reagent/blood))
		return

	mind = null
	ckey = null
	realName = null
	blood_gender = null
	blood_type = null
	features = null
	factions = null
	sampleDNA = null
	contains_sample = FALSE
	return NONE

/obj/item/seeds/replicapod/get_unique_analyzer_text()
	if(contains_sample)
		return "It contains a blood sample with blood DNA (UE) \"[sampleDNA]\"." //blood DNA (UE) shows in medical records and is readable by forensics scanners
	else
		return null

/obj/item/seeds/replicapod/harvest(mob/user) //now that one is fun -- Urist
	return
