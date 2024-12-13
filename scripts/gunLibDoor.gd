extends Interactable
@export var fix : Node3D
@onready var message = $lazyfix/CanvasGroup
var read = false

func _ready() -> void:
	message.hide()

func _on_interacted(body: Variant) -> void:
	
		if read == false:
			message.show()
			read = true
			$door.start()
			
		elif read == true:
			message.hide()
			read = false


func _on_door_timeout() -> void:
	message.hide()
	read = false
