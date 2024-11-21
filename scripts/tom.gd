extends CharacterBody3D

var speed = 4.0
@onready var nav_agent = $NavigationAgent3D
@export var marker:Marker3D

func _physics_process(_delta: float) -> void:	
	
	
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		nav_agent.target_position = marker.global_position
