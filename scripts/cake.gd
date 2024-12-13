extends Interactable

@onready var animator = $"../AnimationPlayer"

func _ready() -> void:
	animator.play("turn")


func _on_interacted(body: Variant) -> void:
	print(GlobalVariables.cakeTaken)
	GlobalVariables.cakeTaken = true
	$"..".hide()
	print(GlobalVariables.cakeTaken)
