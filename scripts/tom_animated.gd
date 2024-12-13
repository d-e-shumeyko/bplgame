extends Node3D
class_name tomAnimated

signal trap (trap: bool)
 
@onready var animatree: AnimationTree = %AnimationTree
var trap_closed = false

func _ready() -> void:
	animatree  = %AnimationTree
func trapClosed():
	trap_closed = true
	emit_signal("trap", trap_closed)
func trapOpen():
	trap_closed = false
	emit_signal("trap", trap_closed)
