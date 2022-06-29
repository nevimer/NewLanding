/datum/surgery/revival
	name = "Revival"
	desc = "An experimental surgical procedure which involves reconstruction and reactivation of the patient's brain even long after death. The body must still be able to sustain life."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/revive,
		/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery/revival/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	if(target.stat != DEAD)
		return FALSE
	if(target.suiciding || HAS_TRAIT(target, TRAIT_HUSK))
		return FALSE
	var/obj/item/organ/brain/target_brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/revive
	name = "shock body"
	implements = list()
	repeatable = TRUE
	time = 5 SECONDS

/datum/surgery_step/revive/tool_check(mob/user, obj/item/tool)
	. = TRUE

/datum/surgery_step/revive/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, SPAN_NOTICE("You prepare to give [target]'s brain the spark of life with [tool]."),
		SPAN_NOTICE("[user] prepares to shock [target]'s brain with [tool]."),
		SPAN_NOTICE("[user] prepares to shock [target]'s brain with [tool]."))
	target.notify_ghost_cloning("Someone is trying to zap your brain.", source = target)

/datum/surgery_step/revive/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(user, target, SPAN_NOTICE("You successfully shock [target]'s brain with [tool]..."),
		SPAN_NOTICE("[user] send a powerful shock to [target]'s brain with [tool]..."),
		SPAN_NOTICE("[user] send a powerful shock to [target]'s brain with [tool]..."))
	playsound(get_turf(target), 'sound/magic/lightningbolt.ogg', 50, TRUE)
	target.grab_ghost()
	target.adjustOxyLoss(-50, 0)
	target.updatehealth()
	if(target.revive(full_heal = FALSE, admin_revive = FALSE))
		target.visible_message(SPAN_NOTICE("...[target] wakes up, alive and aware!"))
		target.emote("gasp")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50, 199) //MAD SCIENCE
		return TRUE
	else
		target.visible_message(SPAN_WARNING("...[target.p_they()] convulses, then lies still."))
		return FALSE

/datum/surgery_step/revive/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, SPAN_NOTICE("You shock [target]'s brain with [tool], but [target.p_they()] doesn't react."),
		SPAN_NOTICE("[user] send a powerful shock to [target]'s brain with [tool], but [target.p_they()] doesn't react."),
		SPAN_NOTICE("[user] send a powerful shock to [target]'s brain with [tool], but [target.p_they()] doesn't react."))
	playsound(get_turf(target), 'sound/magic/lightningbolt.ogg', 50, TRUE)
	target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 180)
	return FALSE
