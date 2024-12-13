extends Node3D
@export var audio : AudioStreamPlayer3D 
var middleBool = false



func _on_cake_visibility_changed() -> void:
	audio.play()
