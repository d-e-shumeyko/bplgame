extends Control

#SLIDE ONE
@export var slide1 : BoxContainer
@export var slide2 : BoxContainer
@export var slide3: BoxContainer
@export var slide4 : BoxContainer
@export var animat :AnimationPlayer

@export var tController : transitionController
var transIn = "fadein"
var transOut = "fadeout"



func _ready() -> void:
	tController.transition(transIn)
	await tController.animplay.animation_finished
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed() -> void:
	slide1.hide()
	slide2.show()


func _on_button_2_pressed() -> void:	
	slide2.hide()
	$toob.hide()
	$cans.hide()
	$cake.hide()
	slide3.show()


func _on_button_3_pressed() -> void:
	slide3.hide()
	slide4.show()


func _on_button_4_pressed() -> void:
	animat.play("fade")

func changeScene():
	get_tree().change_scene_to_file("res://scenes/transitions/credits.tscn")
