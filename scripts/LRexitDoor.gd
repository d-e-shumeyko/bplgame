extends Interactable
@export var tController : transitionController
var transIn = "fadein"
var transOut = "fadeout"

func  _ready() -> void:
	tController.transition(transIn)
	await tController.animplay.animation_finished
	

func _on_interacted(body: Variant) -> void:
	if GlobalVariables.toobTaken == true:
		if GlobalVariables.throughSceneSelect == true:
			tController.transition(transOut)
			await tController.animplay.animation_finished
			GlobalVariables.throughSceneSelect = false
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
		else:
			tController.transition(transOut)
			await tController.animplay.animation_finished
			get_tree().change_scene_to_file("res://scenes/outro.tscn")
