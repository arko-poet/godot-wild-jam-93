extends Node2D

const THUMBLEWHEELS = preload("uid://cxk28ehhsdagj")

var timer: float = 2
var max_spawn: int = 1
func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = randf_range(0.5, 10)
		max_spawn = int(randf_range(1, 4.5))
		for i in max_spawn:
			await get_tree().create_timer(randf_range(0.01, 0.5)).timeout
			var t = THUMBLEWHEELS.instantiate()
			
			add_child(t)
	
