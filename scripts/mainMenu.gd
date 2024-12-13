extends Node3D

@export var main : VBoxContainer
@export var options : VBoxContainer
@export var sceneSelect : VBoxContainer

@export var mainSlider : HSlider
@export var musicSlider : HSlider
@export var sfxSlider : HSlider

var mainIndex = 0
var musicIndex = 1
var sfxIndex = 2

var mainName = "Master"
var musicName = "Music"
var sfxName = "SFX"

var volume : float

@onready var mainValue  = GlobalVariables.mainLoud
@onready var musicValue = GlobalVariables.musicLoud
@onready var sfxValue = GlobalVariables.sfxLoud

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mainIndex = AudioServer.get_bus_index(mainName)
	musicIndex = AudioServer.get_bus_index(musicName)
	sfxIndex = AudioServer.get_bus_index(sfxName)
	AudioServer.set_bus_volume_db(mainIndex,linear_to_db(mainValue))
	AudioServer.set_bus_volume_db(musicIndex, linear_to_db(musicValue))
	AudioServer.set_bus_volume_db(sfxIndex,linear_to_db(sfxValue))



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/transitions/intro.tscn")

func _on_options_pressed() -> void:
	main.hide()
	sceneSelect.hide()
	options.show()

func _on_scene_pressed() -> void:
	main.hide()
	options.hide()
	sceneSelect.show()
	GlobalVariables.throughSceneSelect = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_o_pressed() -> void:
	options.hide()
	sceneSelect.hide()
	main.show()


func _on_back_s_pressed() -> void:
	options.hide()
	sceneSelect.hide()
	main.show()
	GlobalVariables.throughSceneSelect = false


func _on_main_slider_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(mainIndex, linear_to_db(mainSlider.value))
	GlobalVariables.mainLoud = mainSlider.value


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(musicIndex, linear_to_db(musicSlider.value))
	GlobalVariables.musicLoud = musicSlider.value


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(sfxSlider.value))
	GlobalVariables.sfxLoud = sfxSlider.value


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/transitions/credits.tscn")





func _on_scene_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/transitions/beanhouse.tscn")


func _on_scene_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/transitions/forest.tscn")


func _on_scene_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/transitions/locationRedacted.tscn")
