extends Node3D
class_name  animated
signal bearTrap (status : bool)
@onready var animtree: AnimationTree = %AnimationTree
var trap_closed = false



func trapClosed():
	trap_closed = true
	emit_signal("bearTrap",true)

func trapOpen():
	trap_closed = false
	emit_signal("bearTrap",false)
