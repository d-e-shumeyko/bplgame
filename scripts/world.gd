extends Node3D

@export var player : Player

func _physics_process(_delta: float) -> void:
	pass
	#get_tree().call_group("Enemies", "idle_wander", player.global_transform.origin)
