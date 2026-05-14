extends Line2D

@export var trail_max_size: int = 100

var stop = false
var _root
func _process(delta: float) -> void:
	
	if get_point_count() > trail_max_size or stop:
		remove_point(0)

	add_point(_root.global_position)
