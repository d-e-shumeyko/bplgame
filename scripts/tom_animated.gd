extends Node3D
class_name tomAnimated


 
@onready var animtree: AnimationTree = $AnimationTree
var trap_closed = false



func trapClosed():
	trap_closed = true
func trapOpen():
	trap_closed = false
