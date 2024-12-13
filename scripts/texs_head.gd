extends Node3D
class_name tex_head
@export var timer : Timer
@onready var area : Area3D = $visionArea
@onready var ray : RayCast3D = $RayCast3D
signal playerVisible(detected:bool)
var seen = false
var inCone = false






#func _on_vision_area_body_exited(body: Node3D) -> void:
	#var overlaping
	#overlaping = area.get_overlapping_bodies()
	#if overlaping.size() > 0:
		#for overlaps in overlaping:
			#if overlaps.name == "player":
				#inCone = false
#
#
#func _on_vision_area_body_entered(body: Node3D) -> void:
	#var overlaping
	#overlaping = area.get_overlapping_bodies()
	#if overlaping.size() > 0:
		#for overlaps in overlaping:
			#if overlaps.name == "player":
				#inCone = true


func _on_timer_timeout() -> void:
	var overlap
	overlap = area.get_overlapping_bodies()
	
	if overlap.size() > 0:		
		for overlaps in overlap:
			if overlaps.name == "player":
				var playerPosition = overlaps.global_transform.origin
				ray.look_at(playerPosition, Vector3.UP)
				ray.force_raycast_update()
				if ray.is_colliding():
					var collider = ray.get_collider()
					print("colliding")
					if collider.name == "player":
						seen = true
						emit_signal("playerVisible", seen)
						
					else:
						seen = false						
						print("this is colliding not")
						emit_signal("playerVisible", seen)
						
