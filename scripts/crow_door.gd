extends Interactable
var peeked = false
@onready var animator = $"../AnimationPlayer"

func _on_interacted(body: Variant) -> void:
	if Input.is_action_pressed("Interact") && peeked == false:
		animator.play("crowOpen")
	elif Input.is_action_pressed("Interact") && peeked == true:
		animator.play("crowClose")


func has_peeked():
	peeked = false

func will_peek():
	peeked = true
