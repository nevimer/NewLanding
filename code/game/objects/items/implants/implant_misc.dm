/obj/item/implant/weapons_auth
	name = "firearms authentication implant"
	desc = "Lets you shoot your guns."
	icon_state = "auth"
	activated = FALSE

/obj/item/implant/weapons_auth/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Firearms Authentication Implant<BR>
				<b>Life:</b> 4 hours after death of host<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Allows operation of implant-locked weaponry, preventing equipment from falling into enemy hands."}
	return dat

/obj/item/implant/emp
	name = "emp implant"
	desc = "Triggers an EMP."
	icon_state = "emp"
	uses = 3

/obj/item/implant/emp/activate()
	. = ..()
	uses--
	empulse(imp_in, 3, 5)
	if(!uses)
		qdel(src)

/obj/item/implanter/emp
	name = "implanter (EMP)"
	imp_type = /obj/item/implant/emp


//Health Tracker Implant

/obj/item/implant/health
	name = "health implant"
	activated = FALSE
	var/healthstring = ""

/obj/item/implant/health/proc/sensehealth()
	if (!imp_in)
		return "ERROR"
	else
		if(isliving(imp_in))
			var/mob/living/L = imp_in
			healthstring = "<small>Oxygen Deprivation Damage => [round(L.getOxyLoss())]<br />Fire Damage => [round(L.getFireLoss())]<br />Toxin Damage => [round(L.getToxLoss())]<br />Brute Force Damage => [round(L.getBruteLoss())]</small>"
		if (!healthstring)
			healthstring = "ERROR"
		return healthstring
