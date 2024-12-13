extends Node3D


const SPEED = 80.0

@onready var mesh = $MeshInstance3D
@onready var ray = $MeshInstance3D/RayCast3D
@onready var particle = $GPUParticles3D
@export var hit : Area3D
@export var canvas : CanvasGroup
@export var animation: AnimationPlayer

func _ready() -> void:
	canvas.hide()


func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	
	if ray.is_colliding():
		mesh.hide()
		particle.emitting = true
		await get_tree().create_timer(.5).timeout
		queue_free()

func diededed():
	get_tree().change_scene_to_file("res://scenes/locationRedacted.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	GlobalVariables.hardballed = true
	print("shot")
	animation.play("shot")
