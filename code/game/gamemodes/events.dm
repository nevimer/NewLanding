/proc/power_failure()
	priority_announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure", ANNOUNCER_POWEROFF)

/proc/power_restore()
	priority_announce("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", ANNOUNCER_POWERON)

/proc/power_restore_quick()

	priority_announce("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", ANNOUNCER_POWERON)

