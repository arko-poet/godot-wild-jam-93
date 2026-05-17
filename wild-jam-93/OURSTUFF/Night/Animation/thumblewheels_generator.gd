extends Node2D

const THUMBLEWHEELS = preload("uid://cxk28ehhsdagj")

var timer: float = 10
var max_spawn: int = 1
func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = randf_range(0.5, 10)
		max_spawn = int(randf_range(1, 3.5))
		for i in max_spawn:
			var t = THUMBLEWHEELS.instantiate()
			add_child(t)
	
