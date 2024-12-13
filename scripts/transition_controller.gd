class_name transitionController
extends Control
@export var background : ColorRect
@export var animplay : AnimationPlayer

func transition(anim : String) -> void:
	animplay.play(anim)
	
func changScene():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
