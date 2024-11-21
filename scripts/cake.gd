extends Interactable

@onready var animator = $"../AnimationPlayer"

func _ready() -> void:
	animator.play("turn")
