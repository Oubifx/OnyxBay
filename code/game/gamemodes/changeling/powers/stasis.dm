
//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/living/carbon/human/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis"

	if(mind.changeling.is_revive_ready)
		if(mind.changeling.true_dead)
			to_chat(src, SPAN("changeling", "We can not do this. We are really dead."))
		else
			mind.changeling.chem_charges = 0
			mind.changeling.is_revive_ready = FALSE
			revive(ignore_prosthetic_prefs = TRUE) // Complete regeneration
			status_flags &= ~(FAKEDEATH)
			update_canmove()
			to_chat(src, SPAN("changeling", "We have regenerated."))
			clear_fullscreens()
		return

	if(mind.changeling.true_dead)
		to_chat(src, SPAN("changeling", "We can not do this. We are really dead."))
		return

	if(is_regenerating())
		to_chat(usr, SPAN("changeling", "We're still regenerating."))
		return

	if(!stat && alert("Are we sure we wish to fake our death?",,"Yes","No") == "No") // Confirmation for living changelings if they want to fake their death
		return

	changeling_fakedeath_proc()

	to_chat(usr, SPAN("changeling", "We're starting to regenerate."))

	addtimer(CALLBACK(src, .proc/revive_ready), rand(80 SECONDS, 200 SECONDS))

/mob/living/carbon/human/proc/revive_ready()
	if(QDELETED(src))
		return
	mind.changeling.is_revive_ready = TRUE
	to_chat(src, SPAN("changeling", "<font size='5'>We are ready to rise. Use the <b>Regenerative Stasis</b> verb when we are ready.</font>"))

	feedback_add_details("changeling_powers", "FD")

/mob/living/carbon/human/proc/changeling_fakedeath_proc()
	status_flags |= FAKEDEATH
	update_canmove()

	emote("gasp")

	if(has_brain())
		internal_organs_by_name[BP_BRAIN].die()

	clear_fullscreens()
	set_fullscreen(TRUE, "oxydamageoverlay", /obj/screen/fullscreen/oxy, 7)

	death(0)
