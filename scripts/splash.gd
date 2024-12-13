extends Control
@export var animSplash : AnimationPlayer
@export var tController : transitionController
@export var s = preload("res://scenes/mainMenu.tscn")

var transIn = "fadein"
var transOut = "fadeout"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tController.transition(transIn)
	await tController.animplay.animation_finished
	animSplash.play("logoG")
	get_tree()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await animSplash.animation_finished
	animSplash.play("logoB")

	changeScene()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
		pass

func changeScene():
	pass
	
