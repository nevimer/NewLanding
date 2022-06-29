/datum/round_event_control/camera_failure
	name = "Camera Failure"
	typepath = /datum/round_event/camera_failure
	weight = 100
	max_occurrences = 20
	alert_observers = FALSE

	track = EVENT_TRACK_MUNDANE
	tags = list(TAG_DESTRUCTIVE)

/datum/round_event/camera_failure
	fakeable = FALSE

/datum/round_event/camera_failure/start()
	return
