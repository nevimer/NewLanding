#define SHOWCASE_CONSTRUCTED 1
#define SHOWCASE_SCREWDRIVERED 2

/*Completely generic structures for use by mappers to create fake objects, i.e. display rooms*/
/obj/structure/showcase
	name = "showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = TRUE
	anchored = TRUE
	var/deconstruction_state = SHOWCASE_CONSTRUCTED

/obj/structure/showcase/fakeid
	name = "\improper CentCom identification console"
	desc = "You can use this to change ID's."
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"

/obj/structure/showcase/fakeid/Initialize()
	. = ..()
	add_overlay("id")
	add_overlay("id_key")

/obj/structure/showcase/fakesec
	name = "\improper CentCom security records"
	desc = "Used to view and edit personnel's security records."
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"

/obj/structure/showcase/fakesec/update_overlays()
	. = ..()
	. += "security"
	. += "security_key"

/obj/structure/showcase/horrific_experiment
	name = "horrific experiment"
	desc = "Some sort of pod filled with blood and viscera. You swear you can see it moving..."
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_g" // Please don't delete it and not notice it for months this time.

//Deconstructing
//Showcases can be any sprite, so it makes sense that they can't be constructed.
//However if a player wants to move an existing showcase or remove one, this is for that.

/obj/structure/showcase/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_SCREWDRIVER && !anchored)
		if(deconstruction_state == SHOWCASE_SCREWDRIVERED)
			to_chat(user, SPAN_NOTICE("You screw the screws back into the showcase."))
			W.play_tool_sound(src, 100)
			deconstruction_state = SHOWCASE_CONSTRUCTED
		else if (deconstruction_state == SHOWCASE_CONSTRUCTED)
			to_chat(user, SPAN_NOTICE("You unscrew the screws."))
			W.play_tool_sound(src, 100)
			deconstruction_state = SHOWCASE_SCREWDRIVERED

	if(W.tool_behaviour == TOOL_CROWBAR && deconstruction_state == SHOWCASE_SCREWDRIVERED)
		if(W.use_tool(src, user, 20, volume=100))
			to_chat(user, SPAN_NOTICE("You start to crowbar the showcase apart..."))
			new /obj/item/stack/sheet/iron(drop_location(), 4)
			qdel(src)

	if(deconstruction_state == SHOWCASE_CONSTRUCTED && default_unfasten_wrench(user, W))
		return

//Feedback is given in examine because showcases can basically have any sprite assigned to them

/obj/structure/showcase/examine(mob/user)
	. = ..()

	switch(deconstruction_state)
		if(SHOWCASE_CONSTRUCTED)
			. += "The showcase is fully constructed."
		if(SHOWCASE_SCREWDRIVERED)
			. += "The showcase has its screws loosened."
		else
			. += "If you see this, something is wrong."
