extends Interactable
var has_interacted = false

func _on_interacted(body: Variant) -> void:
	if has_interacted == false:
		$"../CanvasGroup".show()
		has_interacted = true
	elif  has_interacted == true:
		$"../CanvasGroup".hide()
		has_interacted = false
	
