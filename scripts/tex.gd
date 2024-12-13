extends Node3D
@export var head : Node3D
@export var player : Player
@export var detectionArea: Area3D
@export var desk : texDesk
@onready var gunAnim = $smg/AnimationPlayer
@onready var sweepAnim: AnimationPlayer = $sweeper/AnimationPlayer
@onready var detectRay : RayCast3D= $RayCast3D
@onready var sweeperRay : RayCast3D = $sweeper
@onready var timer : Timer = $Timer

@onready var reloadSound = load("res://audio/thompson/reload.wav")

@export var trainController : AnimationPlayer
@export var sniperElite: AudioStreamPlayer3D
@export var barksPlayer : AudioStreamPlayer3D
@export var gunPlayer: AudioStreamPlayer3D
@export var barksAudio : Array [String]
@export var thompsonAudio : Array [String]
@export var pillar : Node3D

var bullet = load("res://scenes/decorations/bullet.tscn")
var instance
var playerDetectable = false
var playerDetected = false
var safetyColor:int
signal  HUDColor(index:int)
var theButtonHasBeenPushed = false
var trainTime = false

func _ready() -> void:
	head.connect("playerVisible", detectionMethod)
	pillar.connect("buttonPushed", _buttonHBP)
	#axis_lock_angular_x
	#axis_lock_angular_z
	

func _physics_process(delta: float) -> void:
	
	
	if playerDetectable == true:
		if playerDetected:
			look_at(Vector3(player.global_position.x, -1, global_position.z))
			if  detectRay.is_colliding():
				desk.yellow.hide()
				desk.red.show()
				emit_signal("HUDColor", 2)
				gunPlayer.stream = gunshotAudio()
				gunPlayer.play()
				await get_tree().create_timer(.5).timeout
				if !gunAnim.is_playing():
					gunAnim.play("shoot")
					
					instance = bullet.instantiate()
					instance.position = $RayCast3D.global_position
					instance.transform.basis = $RayCast3D.global_transform.basis
					get_parent().add_child(instance)
			else:
				desk.red.hide()
				desk.yellow.show()			
				emit_signal("HUDColor", 1)
				
				#detected = false
		else:
			self.rotation_degrees = Vector3(0, 90, 0)
				
		

#func _unhandled_input(event: InputEvent) -> void:
	

func barks():
	var randBark = load(barksAudio[randi() % barksAudio.size()])
	return randBark

func gunshotAudio():
	var randGunshot = load(thompsonAudio[randi() % thompsonAudio.size()])
	return randGunshot

func detectionMethod(seen:bool):
	playerDetected = seen

func _on_detectable_area_body_entered(body: Node3D) -> void:
	playerDetectable = true
	desk.green.hide()
	desk.yellow.show()
	emit_signal("HUDColor", 1)
	print(playerDetectable)


func _on_detectable_area_body_exited(body: Node3D) -> void:
	playerDetectable = false
	desk.green.show()
	desk.yellow.hide()
	desk.red.hide()
	emit_signal("HUDColor",0)
	if theButtonHasBeenPushed == true && trainTime == false:
		trainController.play("train")
		


func _on_timer_timeout() -> void:
	print("timer")
	sweepAnim.play("sweep")
	timer.wait_time = randi_range(3,12)
	timer.start()
	
func _buttonHBP(status:bool):
	theButtonHasBeenPushed = status
