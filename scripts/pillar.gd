extends Node3D
@export var bookcase : AnimationPlayer
@export var light : SpotLight3D
signal buttonPushed (status:bool)
func  _ready() -> void:
	$StaticBody3D.connect ("buttonPushed", _activateSecretDoor)
	

func _activateSecretDoor(pushed: bool):
	if pushed == true:
		bookcase.play("secretDoor")
		light.show()
		emit_signal("buttonPushed", pushed)
