extends Interactable
@export var tController : transitionController
var transIn = "fadein"
var transOut = "fadeout"
@export var message: CanvasGroup
var read = false

func  _ready() -> void:
	tController.transition(transIn)
	await tController.animplay.animation_finished

func _on_interacted(body: Variant) -> void:

	if GlobalVariables.cakeTaken == true:
		if GlobalVariables.throughSceneSelect == true:
			tController.transition(transOut)
			await tController.animplay.animation_finished
			GlobalVariables.throughSceneSelect = false
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
		else:
			tController.transition(transOut)
			await tController.animplay.animation_finished
			get_tree().change_scene_to_file("res://scenes/transitions/locationRedacted.tscn")
	else:
		if read == false:
			message.show()
			read = true
			await get_tree().create_timer(5).timeout
			message.hide()
			read = false
		elif read == true:
			message.hide()
			read = false
