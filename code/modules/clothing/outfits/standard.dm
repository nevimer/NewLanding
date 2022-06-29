/datum/outfit/debug //Debug objs plus hardsuit
	name = "Debug outfit"

	id = /obj/item/card/id/advanced/debug
	uniform = /obj/item/clothing/under/misc/patriotsuit
	back = /obj/item/storage/backpack/holding
	backpack_contents = list(
		/obj/item/melee/transforming/energy/axe = 1,
		/obj/item/debug/human_spawner = 1,
		/obj/item/debug/omnitool = 1,
)
	belt = /obj/item/storage/belt/utility/chief/full
	glasses = /obj/item/clothing/glasses/debug
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/welding/up
	shoes = /obj/item/clothing/shoes/magboots/advance

	box = /obj/item/storage/box/debugtools
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/debug/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/admin //for admeem shenanigans and testing things that arent related to equipment, not a subtype of debug just in case debug changes things
	name = "FRET Agent (Admin outfit)"

	id = /obj/item/card/id/advanced/debug/fret
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/hooded/ablative
	back = /obj/item/storage/backpack/holding/debug
	backpack_contents = list(
		/obj/item/melee/transforming/energy/axe = 1,
		/obj/item/debug/human_spawner = 1,
		/obj/item/debug/omnitool = 1,
	)
	belt = /obj/item/storage/belt/utility/chief/full
	glasses = /obj/item/clothing/glasses/debug
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = null
	shoes = /obj/item/clothing/shoes/combat/debug
	box = /obj/item/storage/box/debugtools

/datum/outfit/admin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/admin/hardsuit
	name = "FRET Agent (Hardsuit)"
	mask = /obj/item/clothing/mask/gas/welding/up
	shoes = /obj/item/clothing/shoes/magboots/advance
	internals_slot = ITEM_SLOT_SUITSTORE
