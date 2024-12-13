extends CharacterBody3D

@export var head : Node3D
@export var gunAnim : AnimationPlayer
@export var headAnima : AnimationPlayer
@export var gunPlayer : AudioStreamPlayer3D
@export var sweeperRay : RayCast3D
@export var player : Player
@export var detectRay : RayCast3D
@export var barksPlayer : AudioStreamPlayer3D
var bullet = load("res://scenes/decorations/bullet.tscn")
var instance
var playerDetected = false
var active = false
@export var barksAudio : Array [AudioStreamWAV]
@export var timer : Timer
@export var desk : Node3D

func _ready() -> void:
	head.connect("playerVisible", detectionMethod)

func _physics_process(delta: float) -> void:
	if active == true:
		if playerDetected == true:
			if  detectRay.is_colliding():
				headAnima.play("RESET")
				$".".look_at(Vector3(player.global_position.x, -.5, player.global_position.z))
				shootGun()
		

		

func randomBark():
	var bark = barksAudio[randi() % barksAudio.size()]
	return bark

func detectionMethod(seen:bool):
	pass

func shootGun():
	if GlobalVariables.hardballed == false:
		if !gunAnim.is_playing():
			gunAnim.play("fire")
			gunPlayer.stream_paused = false
			if gunPlayer.finished:
				gunPlayer.stream = load("res://audio/thompson/smallburst.wav")
				gunPlayer.play()
			instance = bullet.instantiate()
			instance.position = sweeperRay.global_position
			instance.transform.basis = sweeperRay.global_transform.basis
			get_parent().add_child(instance)
		


func _on_visibility_changed() -> void:
	active = true
	playerDetected = false
	headAnima.play("sweep")
	timer.start()
	desk.green.hide()
	desk.red.show()
	


func _on_texs_head_player_visible(detected: bool) -> void:
	playerDetected = detected


func _on_timer_timeout() -> void:
	timer.wait_time = randi_range(2,5)
	barksPlayer.stream = randomBark()
	barksPlayer.play()
	if barksPlayer.finished:
		timer.start()
