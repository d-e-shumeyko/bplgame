extends Control
@export var fadeanim : AnimationPlayer
@export var thanks : Label
@export var credits : VBoxContainer
@export var slide1 : BoxContainer
@export var slide2 : BoxContainer

func _ready() -> void:
	fadeanim.play("fadeIn",)


func goToMainMenu():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Sprint"):
		fadeanim.speed_scale = 2.0
	elif Input.is_action_just_released("Sprint"):
		fadeanim.speed_scale = 1.0
	if Input.is_action_pressed("Jump"):
		goToMainMenu()
