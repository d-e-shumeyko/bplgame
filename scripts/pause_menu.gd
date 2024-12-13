extends Control



@export var game_manager : gameManager
signal colorBHud
signal noColorBhud


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	game_manager.connect("toggleGamePAused", _onGameGameMAnagerToggle)
	if game_manager.LR == true:
		$CanvasGroup/VBoxContainer/VBoxContainer/CheckBox.show()
	else:
		$CanvasGroup/VBoxContainer/VBoxContainer/CheckBox.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _onGameGameMAnagerToggle(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()


func _on_button_pressed() -> void:
	$CanvasGroup/VBoxContainer/optionsButton.hide()
	$CanvasGroup/VBoxContainer/VBoxContainer.show()
	$CanvasGroup/VBoxContainer/controls.hide()
	$CanvasGroup/VBoxContainer/quit.hide()
	if game_manager.LR == true:
		$CanvasGroup/VBoxContainer/VBoxContainer/CheckBox.show()
	else:
		$CanvasGroup/VBoxContainer/VBoxContainer/CheckBox.hide()

func _on_back_button_pressed() -> void:
	$CanvasGroup/VBoxContainer/optionsButton.show()
	$CanvasGroup/VBoxContainer/VBoxContainer.hide()
	$CanvasGroup/VBoxContainer/controls.show()
	$CanvasGroup/VBoxContainer/quit.show()


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		emit_signal("colorBHud")
	else:
		emit_signal("noColorBhud")


func _on_controls_pressed() -> void:
	$CanvasGroup/VBoxContainer/optionsButton.hide()
	$CanvasGroup/VBoxContainer/controls.hide()
	$CanvasGroup/VBoxContainer/quit2.hide()
	$CanvasGroup/VBoxContainer/controls2.show()
	$CanvasGroup/VBoxContainer/quit.hide()

func _on_back_c_pressed() -> void:
	$CanvasGroup/VBoxContainer/optionsButton.show()
	$CanvasGroup/VBoxContainer/controls.show()
	$CanvasGroup/VBoxContainer/quit.show()
	$CanvasGroup/VBoxContainer/controls2.hide()

func _on_quit_pressed() -> void:
	$CanvasGroup/VBoxContainer/optionsButton.hide()
	$CanvasGroup/VBoxContainer/controls.hide()
	$CanvasGroup/VBoxContainer/controls2.hide()
	$CanvasGroup/VBoxContainer/quit2.show()
	$CanvasGroup/VBoxContainer/quit.hide()

func _on_to_menu_pressed() -> void:
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func _on_to_options_pressed() -> void:
	$CanvasGroup/VBoxContainer/optionsButton.show()
	$CanvasGroup/VBoxContainer/controls.show()
	$CanvasGroup/VBoxContainer/quit.show()
	$CanvasGroup/VBoxContainer/quit2.hide()
