extends AudioStreamPlayer


@export var tracks : Array [AudioStreamWAV]

#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_pressed("Sprint"):
		#stream = tracks[1]
	#else:
		#stream = tracks[0]
