extends Node3D
@export var tController : transitionController
var transIn = "fadein"
var transOut = "fadeout"



func _ready() -> void:
	tController.transition(transIn)
	await tController.animplay.animation_finished
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_button_pressed() -> void:
	tController.transition(transOut)
	await tController.animplay.animation_finished
	get_tree().change_scene_to_file("res://scenes/forest.tscn")
