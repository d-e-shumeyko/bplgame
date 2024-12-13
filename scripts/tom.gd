extends CharacterBody3D
class_name tom
@onready var npc_body : AnimationTree = %tom2.animatree
@onready var trap = %tom2.trap_closed
var animtree = npc_body
@export var player : Player
@export var tomAudio : AudioStreamPlayer3D
@export var markers : Array[Node]
@export var tomBarks : Array[AudioStreamWAV]
@export var timer : Timer
@export var grabArea : Area3D
@onready var preloaded = preload("res://scenes/cellar.tscn")
var state = States.IDLE
enum States {
	IDLE,
	WALK,
	CHASE,
	GRAB
}

@export var walkSpeed = 3.0
@export var runSpeed = 5.0

var speed = 3.0
@onready var nav_agent = $NavigationAgent3D
@export var randMarker :Marker3D
@export var deathAnimator: AnimationPlayer
var in_grab_zone = false
var moving = false
var playerNoticable = false
var  playerNoticed = false
var playerSafe = false

func _ready() -> void:
	%tom2.connect("trap", changeTrap)

func _physics_process(_delta: float) -> void:	
	if in_grab_zone == true:
		speed = 0
	elif state == States.CHASE:
		speed = runSpeed
	else:
		speed = walkSpeed
	
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	if nav_agent.is_target_reached():
		velocity = Vector3.ZERO
	move_and_slide()
	
	if nav_agent.get_next_path_position() != self.global_position:
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
		elif in_grab_zone == true:
			state = States.GRAB
	elif moving == true && playerNoticed == false:
		state = States.WALK
	elif moving == false && playerNoticed == false:
		state = States.IDLE
	
	if (moving == true) && (playerNoticed == false):
		state = States.WALK
	elif (moving == false) && (playerNoticed == false):
		state = States.IDLE
	
	npc_body.set("parameters/conditions/idle", state==States.IDLE)
	
	npc_body.set("parameters/conditions/is_walk", state==States.WALK)
	npc_body.set("parameters/conditions/is_run", state==States.CHASE)
	npc_body.set("parameters/conditions/grab", state==States.GRAB)
	
	var overlap = grabArea.get_overlapping_bodies()
	if overlap.size() > 0:		
		for overlaps in overlap:
			if overlaps.name == "player":
				if trap == true:
					print("grabbed")
					deathAnimator.play("death")
					#activateDeath()
				

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug_shoot"):
		#idle_wander()

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
		target_location = Vector3(global_position.x, 0, global_position.z).normalized()
	else:
		target_location = player.global_transform.origin
		nav_agent.target_position = target_location
		var look : Vector3 = Vector3(target_location.x, 0.0, target_location.z).normalized()

#region player_detection


func _on_long_area_body_entered(body: Node3D) -> void:
	print("found")
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
	if player.was_run:
		playerNoticed = true
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
	idle_wander()
	timer.wait_time = randi_range(10,20)
	timer.start()


func _on_navigation_agent_3d_navigation_finished() -> void:
	look_at(Vector3 (randf_range(-50, 50), 0 , randf_range(-50, 50)).normalized())


func _on_safe_area_body_entered(body: Node3D) -> void:
	playerNoticable = false
	playerNoticed = false
	idle_wander()
	timer.start()


func _on_safe_area_body_exited(body: Node3D) -> void:
	playerSafe = false


func _on_audio_stream_player_3d_finished() -> void:
	print("sound")
	await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	var randBark = tomBarks[randi() % tomBarks.size()]
	tomAudio.stream = randBark
	tomAudio.play()

func changeTrap(status : bool):
	trap = status
	print(status)

func activateDeath():
	GlobalVariables.canNumber = 0
	get_tree().change_scene_to_file("res://scenes/cellar.tscn")
	

	
#func soThething():
	#get_tree().change_scene_to_packed(preloaded)
#
#
#func _on_deathtimer_timeout() -> void:
	
	
