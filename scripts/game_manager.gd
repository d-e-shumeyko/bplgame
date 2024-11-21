extends Node3D
class_name gameManager
signal toggleGamePAused(is_paused : bool)

var gamePaused : bool = false:
	get:
		return gamePaused
	set(value):
		gamePaused = value
		get_tree().paused = gamePaused
		emit_signal("toggleGamePAused", gamePaused)

func _input(event: InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		gamePaused = !gamePaused
		
		if(get_tree().paused):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
