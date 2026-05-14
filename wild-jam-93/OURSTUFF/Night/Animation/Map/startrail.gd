extends Line2D

@export var trail_max_size: int = 80
@export var frequence := 0.2
@export var amplitude := 3.0
@export var coef: float = 1.0

var stop = false

func _process(delta: float) -> void:
	if get_point_count() > trail_max_size or stop:
		if points:
			remove_point(0)
	

	trail_1()
	if stop:
		modulate.a -= 0.02
		if modulate.a <= 0:
			clear_points()
			process_mode = Node.PROCESS_MODE_DISABLED
		return
	add_point(get_parent().position)

func trail_1():
	

	for i in range(points.size()-1):
		
		var dir = (get_point_position(i) - get_point_position(i+1)).normalized()
		var normal = Vector2(-dir.y, dir.x)
		
		var p = points[i]
		var ratio = 1 - (float(i) / points.size())
		var wave = sin(Time.get_ticks_msec() * 0.01 + i * frequence)*coef

		var ratio_amplitude = ratio * amplitude

		set_point_position(i, normal * wave * ratio_amplitude + get_point_position(i))

	
