/*
 * Data HUDs have been rewritten in a more generic way.
 * In short, they now use an observer-listener pattern.
 * See code/datum/hud.dm for the generic hud datum.
 * Update the HUD icons when needed with the appropriate hook. (see below)
 */

/* DATA HUD DATUMS */

/atom/proc/add_to_all_human_data_huds()
	for(var/datum/atom_hud/data/human/hud in GLOB.huds)
		hud.add_to_hud(src)

/atom/proc/remove_from_all_data_huds()
	for(var/datum/atom_hud/data/hud in GLOB.huds)
		hud.remove_from_hud(src)

/datum/atom_hud/data

/datum/atom_hud/data/human/medical
	hud_icons = list(STATUS_HUD, HEALTH_HUD, NANITE_HUD)

/datum/atom_hud/data/human/medical/basic

/datum/atom_hud/data/human/medical/basic/proc/check_sensors(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	var/obj/item/clothing/under/U = H.w_uniform
	if(!istype(U))
		return FALSE
	if(U.sensor_mode <= SENSOR_VITALS)
		return FALSE
	return TRUE

/datum/atom_hud/data/human/medical/basic/add_to_single_hud(mob/M, mob/living/carbon/H)
	if(check_sensors(H))
		..()

/datum/atom_hud/data/human/medical/basic/proc/update_suit_sensors(mob/living/carbon/H)
	check_sensors(H) ? add_to_hud(H) : remove_from_hud(H)

/datum/atom_hud/data/human/medical/advanced

/datum/atom_hud/data/human/security

/datum/atom_hud/data/human/security/basic
	hud_icons = list(ID_HUD)

/datum/atom_hud/data/human/security/advanced
	hud_icons = list(ID_HUD, IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD, WANTED_HUD, NANITE_HUD)

/datum/atom_hud/data/human/fan_hud
	hud_icons = list(FAN_HUD)

/datum/atom_hud/data/diagnostic

/datum/atom_hud/data/diagnostic/basic
	hud_icons = list(DIAG_HUD, DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_BOT_HUD, DIAG_CIRCUIT_HUD, DIAG_TRACK_HUD, DIAG_AIRLOCK_HUD, DIAG_NANITE_FULL_HUD, DIAG_LAUNCHPAD_HUD)

/datum/atom_hud/data/diagnostic/advanced
	hud_icons = list(DIAG_HUD, DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_BOT_HUD, DIAG_CIRCUIT_HUD, DIAG_TRACK_HUD, DIAG_AIRLOCK_HUD, DIAG_NANITE_FULL_HUD, DIAG_LAUNCHPAD_HUD, DIAG_PATH_HUD)

/datum/atom_hud/data/bot_path
	hud_icons = list(DIAG_PATH_HUD)

/datum/atom_hud/abductor
	hud_icons = list(GLAND_HUD)

/* MED/SEC/DIAG HUD HOOKS */

/*
 * THESE HOOKS SHOULD BE CALLED BY THE MOB SHOWING THE HUD
 */

/***********************************************
Medical HUD! Basic mode needs suit sensors on.
************************************************/

//HELPERS

//helper for getting the appropriate health status
/proc/RoundHealth(mob/living/M)
	if(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH)))
		return "health-100" //what's our health? it doesn't matter, we're dead, or faking
	var/maxi_health = M.maxHealth
	if(iscarbon(M) && M.health < 0)
		maxi_health = 100 //so crit shows up right for aliens and other high-health carbon mobs; noncarbons don't have crit.
	var/resulthealth = (M.health / maxi_health) * 100
	switch(resulthealth)
		if(100 to INFINITY)
			return "health100"
		if(90.625 to 100)
			return "health93.75"
		if(84.375 to 90.625)
			return "health87.5"
		if(78.125 to 84.375)
			return "health81.25"
		if(71.875 to 78.125)
			return "health75"
		if(65.625 to 71.875)
			return "health68.75"
		if(59.375 to 65.625)
			return "health62.5"
		if(53.125 to 59.375)
			return "health56.25"
		if(46.875 to 53.125)
			return "health50"
		if(40.625 to 46.875)
			return "health43.75"
		if(34.375 to 40.625)
			return "health37.5"
		if(28.125 to 34.375)
			return "health31.25"
		if(21.875 to 28.125)
			return "health25"
		if(15.625 to 21.875)
			return "health18.75"
		if(9.375 to 15.625)
			return "health12.5"
		if(1 to 9.375)
			return "health6.25"
		if(-50 to 1)
			return "health0"
		if(-85 to -50)
			return "health-50"
		if(-99 to -85)
			return "health-85"
		else
			return "health-100"

//HOOKS

//called when a human changes suit sensors
/mob/living/carbon/proc/update_suit_sensors()
	var/datum/atom_hud/data/human/medical/basic/B = GLOB.huds[DATA_HUD_MEDICAL_BASIC]
	B.update_suit_sensors(src)

//called when a living mob changes health
/mob/living/proc/med_hud_set_health()
	var/image/holder = hud_list[HEALTH_HUD]
	holder.icon_state = "hud[RoundHealth(src)]"
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size

//for carbon suit sensors
/mob/living/carbon/med_hud_set_health()
	..()

//called when a carbon changes stat, virus or XENO_HOST
/mob/living/proc/med_hud_set_status()
	var/image/holder = hud_list[STATUS_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		holder.icon_state = "huddead"
	else
		holder.icon_state = "hudhealthy"

/mob/living/carbon/med_hud_set_status()
	var/image/holder = hud_list[STATUS_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(HAS_TRAIT(src, TRAIT_XENO_HOST))
		holder.icon_state = "hudxeno"
	else if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		if((key || get_ghost(FALSE, TRUE)) && (can_defib() & DEFIB_REVIVABLE_STATES))
			holder.icon_state = "huddefib"
		else
			holder.icon_state = "huddead"
	else
		holder.icon_state = "hudhealthy"

/***********************************************
Security HUDs! Basic mode shows only the job.
************************************************/

//HOOKS

/mob/living/carbon/human/proc/sec_hud_set_ID()
	var/image/holder = hud_list[ID_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	var/sechud_icon_state = wear_id?.get_sechud_job_icon_state()
	if(!sechud_icon_state)
		sechud_icon_state = "hudno_id"
	holder.icon_state = sechud_icon_state
	sec_hud_set_security_status()

/mob/living/proc/sec_hud_set_implants()
	var/image/holder
	for(var/i in list(IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD))
		holder = hud_list[i]
		holder.icon_state = null
	for(var/obj/item/implant/I in implants)
		if(istype(I, /obj/item/implant/tracking))
			holder = hud_list[IMPTRACK_HUD]
			var/icon/IC = icon(icon, icon_state, dir)
			holder.pixel_y = IC.Height() - world.icon_size
			holder.icon_state = "hud_imp_tracking"
		else if(istype(I, /obj/item/implant/chem))
			holder = hud_list[IMPCHEM_HUD]
			var/icon/IC = icon(icon, icon_state, dir)
			holder.pixel_y = IC.Height() - world.icon_size
			holder.icon_state = "hud_imp_chem"
	if(HAS_TRAIT(src, TRAIT_MINDSHIELD))
		holder = hud_list[IMPLOYAL_HUD]
		var/icon/IC = icon(icon, icon_state, dir)
		holder.pixel_y = IC.Height() - world.icon_size
		holder.icon_state = "hud_imp_loyal"

/mob/living/carbon/human/proc/sec_hud_set_security_status()
	var/image/holder = hud_list[WANTED_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	var/perpname = get_face_name(get_id_name(""))
	if(perpname && GLOB.data_core)
		var/datum/data/record/R = find_record("name", perpname, GLOB.data_core.security)
		if(R)
			switch(R.fields["criminal"])
				if("*Arrest*")
					holder.icon_state = "hudwanted"
					return
				if("Incarcerated")
					holder.icon_state = "hudincarcerated"
					return
				if("Paroled")
					holder.icon_state = "hudparolled"
					return
				if("Discharged")
					holder.icon_state = "huddischarged"
					return
	holder.icon_state = null

/***********************************************
Diagnostic HUDs!
************************************************/

/mob/living/proc/hud_set_nanite_indicator()
	var/image/holder = hud_list[NANITE_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = null
	if(HAS_TRAIT(src, TRAIT_NANITE_MONITORING))
		holder.icon_state = "nanite_ping"

//For Diag health and cell bars!
/proc/RoundDiagBar(value)
	switch(value * 100)
		if(95 to INFINITY)
			return "max"
		if(80 to 100)
			return "good"
		if(60 to 80)
			return "high"
		if(40 to 60)
			return "med"
		if(20 to 40)
			return "low"
		if(1 to 20)
			return "crit"
		else
			return "dead"
