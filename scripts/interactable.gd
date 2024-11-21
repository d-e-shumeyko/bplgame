extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message = "Interact"


func Interact(body):
	interacted.emit(body)
