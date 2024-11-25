extends CharacterBody3D
class_name tom
@onready var npc_body : AnimationTree = %tom2.animatree
var animtree = npc_body
@export var player : Player
@export var markers : Array[Node]

var state = States.IDLE
enum States {
	IDLE,
	WALK,
	CHASE,
	GRAB
}

var speed = 5.0
@onready var nav_agent = $NavigationAgent3D
@export var randMarker :Marker3D
var in_grab_zone = false
var moving = false
var playerNoticable = false
var  playerNoticed = false



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
		look_at(nav_agent.get_next_path_position())
		#Vector3( nav_agent.target_position.x, 1, nav_agent.target_position.z)
	else:
		look_at(Vector3( nav_agent.target_position.x, 0, nav_agent.target_position.z))
	nav_agent.get_next_path_position()
	
	
	if velocity != Vector3.ZERO:
		moving = true
	else:
		moving = false
	
	if playerNoticed == true:
		look_at(player.global_position)
		update_player_location(Vector3.ZERO)
		if in_grab_zone == false:
			state = States.CHASE
	elif moving == true && playerNoticed == false:
		state = States.WALK
	elif moving == false && playerNoticed == false:
		state = States.IDLE
	
	
	
	npc_body.set("parameters/conditions/idle", state==States.IDLE)
	
	npc_body.set("parameters/conditions/is_walk", state==States.WALK)
	npc_body.set("parameters/conditions/is_run", state==States.CHASE)
	npc_body.set("parameters/conditions/is_run", state==States.GRAB)

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

func update_player_location(target_location):
	if in_grab_zone == true:
		target_location = Vector3(global_position.x, 0, global_position.z)
	else:
		target_location = player.global_transform.origin
		nav_agent.target_position = target_location
		var look : Vector3 = Vector3(target_location.x, 0.0, target_location.z)

#region player_detection


func _on_long_area_body_entered(body: Node3D) -> void:
	if player.was_run == true:
		playerNoticed == true


func _on_long_area_body_exited(body: Node3D) -> void:
	playerNoticed = false


func _on_short_area_body_entered(body: Node3D) -> void:
	if player.was_walk == true || player.was_run == true:
		playerNoticed = true


func _on_short_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_notice_area_body_entered(body: Node3D) -> void:
	playerNoticable = true
	print("in")
	


func _on_notice_area_body_exited(body: Node3D) -> void:
	playerNoticable = false


func _on_grab_area_body_entered(body: Node3D) -> void:
	in_grab_zone = true
	state = States.GRAB


func _on_grab_area_body_exited(body: Node3D) -> void:
	in_grab_zone = false
#endregion


func _on_timer_timeout() -> void:
	pass # Replace with function body.


func _on_navigation_agent_3d_navigation_finished() -> void:
	look_at(Vector3 (randf_range(-50, 50), 0 , randf_range(-50, 50)).normalized())
