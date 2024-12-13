extends Interactable
var pushed = false
signal buttonPushed (isPushed : bool)

func _on_interacted(body: Variant) -> void:
	if Input.is_action_pressed("Interact"):
		$"../buttonOff".hide()
		$"../buttonOn".show()
		pushed = true
		emit_signal("buttonPushed", pushed)
