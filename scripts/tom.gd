extends CharacterBody3D
@onready var animtree : AnimationTree = $tom2.animtree

@export var markers : Array[Node]
var moving = false
var state = States.IDLE
enum States {
	IDLE,
	WALK,
	CHASE,
	GRAB
}

var speed = 4.0
@onready var nav_agent = $NavigationAgent3D
@export var randMarker :Marker3D


func _physics_process(_delta: float) -> void:	
	
	
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	if nav_agent.is_target_reached():
		velocity = Vector3.ZERO
	move_and_slide()
	
	if nav_agent.is_target_reached() == false:
		#look_at(Vector3( nav_agent.target_position.x, 0, nav_agent.target_position.z))
		look_at(Vector3( nav_agent.target_position.x, 0, nav_agent.target_position.z))
		#Vector3( nav_agent.target_position.x, 1, nav_agent.target_position.z)
	
	
	
	if velocity != Vector3.ZERO:
		moving = true
	else:
		moving = false
	
	animtree.set("parameters/conditions/idle", state==States.IDLE)
	
	animtree.set("parameters/conditions/is_walk", state==States.WALK)
	animtree.set("parameters/conditions/is_run", state==States.CHASE)
	animtree.set("parameters/conditions/grab", state==States.GRAB)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		idle_wander()

func idle_wander():
	var target_location = get_waypoint()
	
	nav_agent.target_position = target_location
	print(nav_agent.target_position)
	

func rand_waypoint():
	var random_waypoint = markers[randi() % markers.size()]
	return random_waypoint

func get_waypoint():
	var random_waypoint =  rand_waypoint().global_position
	if random_waypoint == randMarker.global_position:
		random_waypoint = rand_waypoint().global_position
	randMarker = rand_waypoint()
	return random_waypoint



#region player_detection


func _on_long_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_long_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_short_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_short_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_notice_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_notice_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_grab_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_grab_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
#endregion


func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_navigation_agent_3d_navigation_finished() -> void:
	look_at(Vector3 (randf_range(-50, 50), 0 , randf_range(-50, 50)))
