extends CharacterBody3D

@export var head : Node3D
@export var player : Player
@export var detectionArea: Area3D
@export var desk : texDesk
@export var gunAnim :AnimationPlayer
@export var sweepAnim: AnimationPlayer
@export var detectRay : RayCast3D
@export var sweeperRay : RayCast3D 
@export var timer : Timer 
@export var originalRotation : Vector3
#@export var phase2Marker : Marker3D
@onready var reloadSound = load("res://audio/thompson/reload.wav")
var bullet = load("res://scenes/decorations/bullet.tscn")
@export var trainController : AnimationPlayer
@export var train: Node3D
@export var sniperElite: AudioStreamPlayer3D
@export var barksPlayer : AudioStreamPlayer3D
@export var gunPlayer: AudioStreamPlayer
@export var barksAudio : Array [AudioStreamWAV]
#@export var thompsonAudio : Array [AudioStreamWAV]
@export var pillar : Node3D
@export var toob : Node3D
@export var P2Tex : CharacterBody3D


var notPahse2 = true
var instance
var playerDetectable = false
var playerDetected = false
var safetyColor:int
signal  HUDColor(index:int)
var theButtonHasBeenPushed = false
var trainTime = false
var startRotation : Vector3
enum states {
	IDLE,
	ALERT,
	FIRE,
	PHASE2	
}

var currentState = states.IDLE
var lookAtBool = false
var trainkilled = false

func _ready() -> void:
	startRotation = global_rotation
	head.connect("playerVisible", detectionMethod)
	pillar.connect("buttonPushed", _buttonHBP)
	toob.connect("theToobHasBeenStolen", _phaseTwo)
	gunPlayer.play()
	gunPlayer.stream_paused = true
	barksPlayer.stream = barks()
	GlobalVariables.hardballed = false
	currentState = states.IDLE
	

func _physics_process(delta: float) -> void:
	
	if currentState == states.IDLE:
		playerDetectable = false		
		desk.green.show()
		desk.yellow.hide()
		desk.red.hide()
		emit_signal("HUDColor",0)
		gunPlayer.stream_paused = true
		sniperElite.play()
		if theButtonHasBeenPushed == true && trainTime == false:
			if trainkilled == false:
				trainController.play("train")
	elif currentState == states.ALERT:
		playerDetectable = true
		if barksPlayer.playing:
			sniperElite.stream_paused = true
		if timer.is_stopped():
			timer.start(2)
		desk.green.hide()
		desk.yellow.show()
		desk.red.hide()
		emit_signal("HUDColor", 1)
		gunPlayer.stream_paused = true
		$"..".rotation = startRotation
		if Input.is_action_pressed("Jump") || Input.is_action_pressed("Sprint"):
			playerDetected = true
		if playerDetected:
			currentState = states.FIRE 
	elif currentState == states.FIRE:
		sniperElite.stream_paused = true
		$"..".look_at(Vector3(player.global_position.x, -.5, player.global_position.z))
		timer.stop()			
		desk.yellow.hide()
		desk.red.show()
		sniperElite.stream_paused
		emit_signal("HUDColor", 2)
		barksPlayer.stream = barks()
	
	
	
		if  detectRay.is_colliding():
				shootGun()
		if playerDetected == false:
			barksPlayer.play()
			currentState = states.ALERT


func _phaseTwo(d: bool):
	pass


func barks():
	var randBark = barksAudio[randi() % barksAudio.size()]
	return randBark


	



func detectionMethod(seen:bool):
	playerDetected = seen

func _buttonHBP(status:bool):
	theButtonHasBeenPushed = status



func shootGun():
	if GlobalVariables.hardballed == false:
		if !gunAnim.is_playing():
			gunAnim.play("fire")
			gunPlayer.stream_paused = false
			if gunPlayer.finished:
				gunPlayer.stream = load("res://audio/thompson/smallburst.wav")
				gunPlayer.play()
			instance = bullet.instantiate()
			instance.position = sweeperRay.position
			instance.transform.basis = sweeperRay.transform.basis
			get_parent().add_child(instance)
		

func _on_detectable_area_body_entered(body: Node3D) -> void:
	currentState = states.ALERT


func _on_detectable_area_body_exited(body: Node3D) -> void:
	currentState = states.IDLE
	timer.stop()



func _on_timer_timeout() -> void:
	print("timer")
	timer.wait_time = randi_range(4,10)
	sweepAnim.play("sweep")
	timer.start()
	


func _on_barks_finished() -> void:
	await  get_tree().create_timer(.5).timeout
	sniperElite.stream_paused = false

func killTheTrain():
	trainkilled = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !Input.is_action_pressed("Crouch"):
		currentState = states.FIRE


func _on_area_3d_body_exited(body: Node3D) -> void:
	if currentState != states.FIRE:
		currentState = states.ALERT


func _on_static_body_3d_the_toob_has_been_stolen(status: bool) -> void:
	if status == true:
		P2Tex.show()
		notPahse2 = false
		print("a text")
		currentState = states.PHASE2
		$"..".queue_free()
