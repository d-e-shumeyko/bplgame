extends Interactable
signal canPickedUp (plusOne : bool)
@onready var animator = $"../../AnimationPlayer"

func _ready() -> void:
	animator.play("turn")



func _on_interacted(body: Variant) -> void:
	GlobalVariables.canNumber += 1
	print(GlobalVariables.canNumber)
	$"../..".hide()
	
	
