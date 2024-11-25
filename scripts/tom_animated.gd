extends Node3D
class_name tomAnimated


 
@onready var animatree: AnimationTree = %AnimationTree
var trap_closed = false

func _ready() -> void:
	animatree  = %AnimationTree
func trapClosed():
	trap_closed = true
func trapOpen():
	trap_closed = false
