extends Interactable
var has_interacted = false
var transition = true
var transIn = "fadein"
var transOut = "fadeout"
@export var player : Player
@export var tController : transitionController
var allCansCollected = false

func _ready() -> void:
	tController.transition(transIn)
	await tController.animplay.animation_finished
		

func _physics_process(delta: float) -> void:
	if GlobalVariables.canNumber == 3:
		allCansCollected = true
	



func _on_interacted(body: Variant) -> void:
	print(GlobalVariables.canNumber)
	if allCansCollected == false:
		if has_interacted == false:
			$"../CanvasGroup".show()
			has_interacted = true
			await get_tree().create_timer(5).timeout
			$"../CanvasGroup".hide()
			has_interacted = false
		elif  has_interacted == true:
			$"../CanvasGroup".hide()
			has_interacted = false
	else:
		if GlobalVariables.throughSceneSelect == true:
			tController.transition(transOut)
			await tController.animplay.animation_finished
			GlobalVariables.throughSceneSelect = false
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
		else:
			tController.transition(transOut)
			await tController.animplay.animation_finished
			get_tree().change_scene_to_file("res://scenes/transitions/forest.tscn")
