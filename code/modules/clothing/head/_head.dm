/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'icons/obj/clothing/head/head.dmi'
	worn_icon = 'icons/mob/clothing/head/head.dmi'
	icon_state = "tophat"
	inhand_icon_state = "that"
	body_parts_covered = HEAD
	fitted_bodytypes = BODYTYPE_DIGITIGRADE|BODYTYPE_VOX
	slot_flags = ITEM_SLOT_HEAD
	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null
	dynamic_hair_suffix = "+generic"

/obj/item/clothing/head/Initialize()
	. = ..()
	if(ishuman(loc) && dynamic_hair_suffix)
		var/mob/living/carbon/human/H = loc
		H.update_hair()

///Special throw_impact for hats to frisbee hats at people to place them on their heads/attempt to de-hat them.
/obj/item/clothing/head/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	///if the thrown object's target zone isn't the head
	if(thrownthing.target_zone != BODY_ZONE_HEAD)
		return
	///ignore any hats with the tinfoil counter-measure enabled
	if(clothing_flags & ANTI_TINFOIL_MANEUVER)
		return
	///if the hat happens to be capable of holding contents and has something in it. mostly to prevent super cheesy stuff like stuffing a mini-bomb in a hat and throwing it
	if(LAZYLEN(contents))
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(istype(H.head, /obj/item))
			var/obj/item/WH = H.head
			///check if the item has NODROP
			if(HAS_TRAIT(WH, TRAIT_NODROP))
				H.visible_message(SPAN_WARNING("[src] bounces off [H]'s [WH.name]!"), SPAN_WARNING("[src] bounces off your [WH.name], falling to the floor."))
				return
			///check if the item is an actual clothing head item, since some non-clothing items can be worn
			if(istype(WH, /obj/item/clothing/head))
				var/obj/item/clothing/head/WHH = WH
				///SNUG_FIT hats are immune to being knocked off
				if(WHH.clothing_flags & SNUG_FIT)
					H.visible_message(SPAN_WARNING("[src] bounces off [H]'s [WHH.name]!"), SPAN_WARNING("[src] bounces off your [WHH.name], falling to the floor."))
					return
			///if the hat manages to knock something off
			if(H.dropItemToGround(WH))
				H.visible_message(SPAN_WARNING("[src] knocks [WH] off [H]'s head!"), SPAN_WARNING("[WH] is suddenly knocked off your head by [src]!"))
		if(H.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD, 0, 1, 1))
			H.visible_message(SPAN_NOTICE("[src] lands neatly on [H]'s head!"), SPAN_NOTICE("[src] lands perfectly onto your head!"))
			H.update_inv_hands() //force update hands to prevent ghost sprites appearing when throw mode is on
		return


/obj/item/clothing/head/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damagedhelmet")
	if(HAS_BLOOD_DNA(src))
		if(clothing_flags & LARGE_WORN_ICON)
			. += mutable_appearance('icons/effects/64x64.dmi', "helmetblood_large")
		else
			. += mutable_appearance('icons/effects/blood.dmi', "helmetblood")

/obj/item/clothing/head/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()
