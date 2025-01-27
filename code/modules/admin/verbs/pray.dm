/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, SPAN_DANGER("Speech is currently admin-disabled."), confidential = TRUE)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	log_prayer("[src.key]/([src.name]): [msg]")
	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, SPAN_DANGER("You cannot pray (muted)."), confidential = TRUE)
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/mutable_appearance/cross = mutable_appearance('icons/obj/storage.dmi', "bible")
	var/font_color = "purple"
	var/prayer_type = "PRAYER"
	var/deity
	if(usr.job == "Chaplain")
		cross.icon_state = "kingyellow"
		font_color = "blue"
		prayer_type = "CHAPLAIN PRAYER"
		if(GLOB.deity)
			deity = GLOB.deity
	else if(isliving(usr))
		var/mob/living/L = usr
		if(HAS_TRAIT(L, TRAIT_SPIRITUAL))
			cross.icon_state = "holylight"
			font_color = "blue"
			prayer_type = "SPIRITUAL PRAYER"

	var/msg_tmp = msg
	msg = SPAN_ADMINNOTICE("[icon2html(cross, GLOB.admins)]<b><font color=[font_color]>[prayer_type][deity ? " (to [deity])" : ""]: </font>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]:</b> <span class='linkify'>[msg]</span>")

	for(var/client/C in GLOB.admins)
		if(C.prefs.chat_toggles & CHAT_PRAYER)
			to_chat(C, msg, confidential = TRUE)
			if(C.prefs.toggles & SOUND_PRAYERS)
				if(usr.job == "Chaplain")
					SEND_SOUND(C, sound('sound/effects/pray.ogg'))
	to_chat(usr, SPAN_INFO("You pray to the gods: \"[msg_tmp]\""), confidential = TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Prayer") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/// Used by communications consoles to message CentCom
/proc/message_centcom(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = SPAN_ADMINNOTICE("<b><font color=orange>CENTCOM:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)]:</b> [msg]")
	to_chat(GLOB.admins, msg, confidential = TRUE)

/// Used by communications consoles to message the Syndicate
/proc/message_syndicate(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = SPAN_ADMINNOTICE("<b><font color=crimson>SYNDICATE:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_SYNDICATE_REPLY(sender)]:</b> [msg]")
	to_chat(GLOB.admins, msg, confidential = TRUE)

/// Used by communications consoles to request the nuclear launch codes
/proc/nuke_request(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = SPAN_ADMINNOTICE("<b><font color=orange>NUKE CODE REQUEST:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)] [ADMIN_SET_SD_CODE]:</b> [msg]")
	to_chat(GLOB.admins, msg, confidential = TRUE)
