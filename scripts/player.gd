extends CharacterBody3D


class_name Player

const WALK_SPEED = 4
const SPRINT_SPEED = 6.0
const JUMP_VEL = 4.5 
const SENSITIVITY = 0.003
const CROUCH_SPEED = 2.5
var speed


#head bob
const 	BOB_FREQ =2.0
const  BOB_AMP = 0.08
var t_bob = 0.0
#FOV
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

#signal is_running(is_running:bool)
var was_run : bool = false :
	get:
		return was_run
	set(value):
		was_run = value
#signal is_walking(is_walking:bool)
var was_walk : bool = false :
	get:
		return was_walk
	set(value):
		was_walk = value
#signal is_crouching(is_crouching: bool)
var was_crouch : bool = false :
	get:
		return was_crouch
	set(value):
		was_crouch = value
signal objectInteractedWith(is_interacted : bool)
var was_interacted : bool = false :
	get:
		return was_interacted
	set(value):
		was_interacted = value

var flashlight_on = false

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var body = $Node3D
@onready var raycast : RayCast3D = $head/Camera3D/RayCast3D
@onready var flashlight = $head/Camera3D/SpotLight3D




func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		body.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-50), deg_to_rad(70))
		


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		#Flashlight
	if (Input.is_action_just_pressed("Flashlight")):
		if flashlight_on == false:
			flashlight.show()
			flashlight_on = true
		elif flashlight_on == true:
			flashlight.hide()
			flashlight_on=false
	# Handle Sprint & crouch
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
		run()
	elif Input.is_action_pressed("Crouch"):
		speed = CROUCH_SPEED
		crouch()
	elif Input.is_action_pressed("Crouch") && Input.is_action_pressed("Sprint"):
		speed = WALK_SPEED
		walk()
	else:
		speed = WALK_SPEED
		walk()
	
	
	
		# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VEL
		# Get input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():	
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
			
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)	
	#Head bob
	t_bob += delta * velocity.length() *float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED*2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	

	move_and_slide()

func run():
	was_run = true
	was_walk = false
	was_crouch = false
	#emit_signal("is_running",was_run)
	#emit_signal("is_walking",was_walk)
	#emit_signal("is_crouching",was_crouch)
	#print (was_run,was_walk, was_crouch)

func walk():
	head.transform.origin = Vector3(0,0,-.327)
	was_run = false
	was_walk = true
	was_crouch = false
	#emit_signal("is_running",is_running)
	#emit_signal("is_walking",is_walking)
	#emit_signal("is_crouching",is_crouching)
	#print (was_run,was_walk, was_crouch)

func crouch():
	head.transform.origin = Vector3(0,-.4,-.327)
	was_run = false
	was_walk = false
	was_crouch = true
	#emit_signal("is_running",is_running)
	#emit_signal("is_walking",is_walking)
	#emit_signal("is_crouching",is_crouching)
	#print (was_run,was_walk, was_crouch)


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) *BOB_AMP
	return pos 
	
func _input(event: InputEvent):
	if (event.is_action_pressed("Interact") and raycast.is_colliding()):
		print_debug("hit") 
		was_interacted = true
		emit_signal("objectInteractedWith", was_interacted)
		was_interacted = false
