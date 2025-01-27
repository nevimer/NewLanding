/obj/structure/plasticflaps
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps. Definitely can't get past those. No way."
	gender = PLURAL
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "plasticflaps"
	armor = list(MELEE = 100, BULLET = 80, LASER = 80, ENERGY = 100, BOMB = 50, BIO = 100, RAD = 100, FIRE = 50, ACID = 50)
	density = FALSE
	anchored = TRUE
	CanAtmosPass = ATMOS_PASS_NO

/obj/structure/plasticflaps/opaque
	opacity = TRUE

/obj/structure/plasticflaps/Initialize()
	. = ..()
	alpha = 0
	SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, plane, dir, add_appearance_flags = RESET_ALPHA) //you see mobs under it, but you hit them like they are above it

/obj/structure/plasticflaps/examine(mob/user)
	. = ..()
	if(anchored)
		. += SPAN_NOTICE("[src] are <b>screwed</b> to the floor.")
	else
		. += SPAN_NOTICE("[src] are no longer <i>screwed</i> to the floor, and the flaps can be <b>cut</b> apart.")

/obj/structure/plasticflaps/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	add_fingerprint(user)
	var/action = anchored ? "unscrews [src] from" : "screws [src] to"
	var/uraction = anchored ? "unscrew [src] from" : "screw [src] to"
	user.visible_message(SPAN_WARNING("[user] [action] the floor."), SPAN_NOTICE("You start to [uraction] the floor..."), SPAN_HEAR("You hear rustling noises."))
	if(!W.use_tool(src, user, 100, volume=100, extra_checks = CALLBACK(src, .proc/check_anchored_state, anchored)))
		return TRUE
	set_anchored(!anchored)
	update_atmos_behaviour()
	air_update_turf(TRUE)
	to_chat(user, SPAN_NOTICE("You [uraction] the floor."))
	return TRUE

///Update the flaps behaviour to gases, if not anchored will let air pass through
/obj/structure/plasticflaps/proc/update_atmos_behaviour()
	CanAtmosPass = anchored ? ATMOS_PASS_YES : ATMOS_PASS_NO

/obj/structure/plasticflaps/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(!anchored)
		user.visible_message(SPAN_WARNING("[user] cuts apart [src]."), SPAN_NOTICE("You start to cut apart [src]."), SPAN_HEAR("You hear cutting."))
		if(W.use_tool(src, user, 50, volume=100))
			if(anchored)
				return TRUE
			to_chat(user, SPAN_NOTICE("You cut apart [src]."))
			var/obj/item/stack/sheet/plastic/five/P = new(loc)
			P.add_fingerprint(user)
			qdel(src)
		return TRUE

/obj/structure/plasticflaps/proc/check_anchored_state(check_anchored)
	if(anchored != check_anchored)
		return FALSE
	return TRUE

/obj/structure/plasticflaps/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	if(isliving(caller))

		var/mob/living/living_caller = caller
		var/ventcrawler = HAS_TRAIT(living_caller, TRAIT_VENTCRAWLER_ALWAYS) || HAS_TRAIT(living_caller, TRAIT_VENTCRAWLER_NUDE)
		if(!ventcrawler && living_caller.mob_size != MOB_SIZE_TINY)
			return FALSE

	if(caller?.pulling)
		return CanAStarPass(ID, to_dir, caller.pulling)
	return TRUE //diseases, stings, etc can pass

/obj/structure/plasticflaps/CanAllowThrough(atom/movable/A, turf/T)
	. = ..()
	if(A.pass_flags & PASSFLAPS) //For anything specifically engineered to cross plastic flaps.
		return TRUE
	if(istype(A) && (A.pass_flags & PASSGLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if(istype(A, /obj/structure/bed) && (B.has_buckled_mobs() || B.density))//if it's a bed/chair and is dense or someone is buckled, it will not pass
		return FALSE

	if(istype(A, /obj/structure/closet/cardboard))
		var/obj/structure/closet/cardboard/C = A
		if(C.move_delay)
			return FALSE

	else if(isliving(A)) // You Shall Not Pass!
		var/mob/living/M = A

		var/ventcrawler = HAS_TRAIT(M, TRAIT_VENTCRAWLER_ALWAYS) || HAS_TRAIT(M, TRAIT_VENTCRAWLER_NUDE)
		if(M.body_position == STANDING_UP && !ventcrawler && M.mob_size != MOB_SIZE_TINY) //If your not laying down, or a ventcrawler or a small creature, no pass.
			return FALSE

/obj/structure/plasticflaps/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/plastic/five(loc)
	qdel(src)

/obj/structure/plasticflaps/Initialize()
	. = ..()
	air_update_turf(TRUE, TRUE)

/obj/structure/plasticflaps/Destroy()
	var/atom/oldloc = loc
	. = ..()
	if (oldloc)
		oldloc.air_update_turf(TRUE, FALSE)
