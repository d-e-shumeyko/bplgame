extends CanvasGroup

@export var pauseMenu : Control
@export var controller : Node3D
@onready var safe = $safe
@onready var caution = $caution
@onready var danger = $danger



func _ready() -> void:
	pauseMenu.connect("colorBHud", HUDon)
	pauseMenu.connect("noColorBhud", HUDoff)
	controller.connect("HUDColor", controlHUD)
	
	
func HUDon():
	self.show()

func HUDoff():
	self.hide()

func controlHUD(state:int):
	if state == 0:
		safe.show()
		caution.hide()
		danger.hide()
	elif state == 1:
		safe.hide()
		caution.show()
		danger.hide()
	elif state == 2:
		safe.hide()
		caution.hide()
		danger.show()
