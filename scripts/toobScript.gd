extends Interactable

@onready var animator = $"../AnimationPlayer"
signal theToobHasBeenStolen (status: bool)
func _ready() -> void:
	animator.play("turn")


func _on_interacted(body: Variant) -> void:
	GlobalVariables.toobTaken = true
	emit_signal("theToobHasBeenStolen", true)
	print("stolen")
	$"..".hide()
