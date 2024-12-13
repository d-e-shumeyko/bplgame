extends CharacterBody3D
class_name bear
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@export var walkSpeed = 2.0
var speed = 3.0
@export var runSpeed = 5.0
const SPEED = 4.0
@onready var body = $"."
var is_reached = false
@export var player : Player
@export var wander_range = 10
@export var digsBarks :Array[String]
#@export var barksTimer : Timer
@export var barkAudio : AudioStreamPlayer3D
@export var grabArea : Area3D
@export var deathAnimator : AnimationPlayer
@onready var timer = $Timer
var player_noticed = false
var in_grab_zone = false
var moving = false
var sirenActivated = false
var trap = false
@onready var prev_waypoint = $"../markers/empty".global_position

@onready var animtree : AnimationTree = $BEARanimated.animtree
@onready var waypoints = [
	$"../markers/Marker3D".global_position, 
	$"../markers/Marker3D2".global_position, 
	$"../markers/Marker3D3".global_position,
	$"../markers/Marker3D4".global_position,
	$"../markers/Marker3D5".global_position,
	$"../markers/Marker3D6".global_position,
	$"../markers/Marker3D7".global_position,
	$"../markers/Marker3D8".global_position,
	$"../markers/Marker3D9".global_position,
	$"../markers/Marker3D10".global_position,
	]
var state = States.IDLE
enum States {
	IDLE,
	WALK,
	CHASE,
	GRAB
}

func _ready() -> void:
	$BEARanimated.connect("bearTrap", _bearTrapStatus)


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

	#if nav_agent.is_target_reached() == false:
		#nav_agent.get_next_path_position()
	#else:
		#look_at(Vector3( nav_agent.target_position.x, 0, nav_agent.target_position.z).normalized())
	#nav_agent.get_next_path_position()
	
	var overlap 
	if velocity != Vector3.ZERO:
		moving = true
		look_at(nav_agent.get_next_path_position())
	else:
		moving = false
	
	
	if sirenActivated == false:
		if player_noticed == true:
			update_player_location(Vector3.ZERO)
			if in_grab_zone == false:
				state = States.CHASE
			elif in_grab_zone == true:
				state = States.GRAB
				
		elif moving == true && player_noticed == false:
			state = States.WALK
		elif moving == false && player_noticed == false:
			state = States.IDLE
	else:
		update_player_location(Vector3.ZERO)
		if nav_agent.distance_to_target() >= 15:
			speed = 15
		if in_grab_zone == false:
				state = States.CHASE
		elif in_grab_zone == true:
			state = States.GRAB
			overlap = grabArea.get_overlapping_bodies()
			if overlap.size() > 0:
				for overlaps in overlap:
					if overlaps.name == "player":
						if trap == true:
							print("grabbed")
							deathAnimator.play("death")
		


	
	animtree.set("parameters/conditions/idle", state==States.IDLE)
	animtree.set("parameters/conditions/is_walk", state==States.WALK)
	animtree.set("parameters/conditions/is_chase", state==States.CHASE)
	animtree.set("parameters/conditions/grab", state==States.GRAB)
	
	overlap = grabArea.get_overlapping_bodies()
	if overlap.size() > 0:
		for overlaps in overlap:
			if overlaps.name == "player":
				_bearTrapStatus(trap)
				if trap == true:
					print("grabbed")
					deathAnimator.play("death")



func idle_wander():
	var target_location = get_waypoint()
	
	nav_agent.target_position = target_location
	print(nav_agent.target_position)
	



func update_player_location(target_location):
	if in_grab_zone == true:
		target_location = global_position
	else:
		target_location = player.global_transform.origin
		nav_agent.target_position = target_location
		#var look : Vector3 = Vector3(target_location.x, 0.0, target_location.z).normalized()
	#look_at(look)



func rand_waypoint():
	var random_waypoint = waypoints[randi() % waypoints.size()]
	return random_waypoint

func get_waypoint():
	var random_waypoint =  rand_waypoint()
	if random_waypoint == prev_waypoint:
		random_waypoint = rand_waypoint()
	prev_waypoint = random_waypoint
	return random_waypoint

func _on_timer_timeout() -> void:
	if player_noticed == false:
		idle_wander()
		timer.wait_time = randi_range(5, 15)
		print(timer.wait_time)

#region player detection



func _on_navigation_agent_3d_target_reached() -> void:
	pass
	


func _on_area_3d_body_entered(_body: Node3D) -> void:
	print("enter")
	#$catchTime.start()
	in_grab_zone = true
	print (state)
	

func _on_area_3d_body_exited(_body: Node3D) -> void:
	in_grab_zone = false
	#$catchTime.wait_time = .6
	#$catchTime.stop()
	print("exited")


func _on_short_area_body_entered(body: Node3D) -> void:
	if player.was_walk == true || player.was_run == true:
		player_noticed = true

func _on_long_area_body_entered(body: Node3D) -> void:
	if player.was_run == true:
		player_noticed == true


func _on_long_area_body_exited(body: Node3D) -> void:
	player_noticed = false



func _on_cone_area_body_entered(body: Node3D) -> void:
	player_noticed = true

#func _on_catch_area_body_entered(body: Node3D) -> void:
	#pass # Replace with function body.

#func _on_catch_time_timeout() -> void:
	#$catchTime.wait_time = 2.25
	#if in_grab_zone == true:
		#print("caught")

#func player_caught():
	#if in_grab_zone == true:
		#print("caught")
	



	



#endregion


#func _on_navigation_agent_3d_navigation_finished() -> void:
	#look_at(Vector3 (randf_range(-50, 50), player.global_position.y , randf_range(-50, 50)).normalized())


func _on_cake_visibility_changed() -> void:
	sirenActivated = true

func _bearTrapStatus(s: bool):
	trap = s


#func _on_bark_timer_timeout() -> void:
	#var randBark = load(digsBarks[randi()%digsBarks.size()])
	#barkAudio.play(randBark)
	#barksTimer.wait_time = randi_range(1, 5)
	

func activateDeath():
	get_tree().reload_current_scene()

func _on_bark_player_3d_finished() -> void:
	print("sound")
	await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	var randBark = digsBarks[randi() % digsBarks.size()]
	barkAudio.stream = load(randBark)
	barkAudio.play()
