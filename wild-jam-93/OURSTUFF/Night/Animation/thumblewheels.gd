extends Node2D
class_name ThumbleWheels

var dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
var lifetime: float = randf_range(1, 4)
var speed = randf_range(2, 5)
func _ready() -> void:
	global_position = Vector2(randf_range(50, get_viewport_rect().size.x-50), randf_range(50, get_viewport_rect().size.y - 50))

	
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		modulate.a -= 0.02
	
	if modulate.a <= 0:
		queue_free()
	
	var wave = ((sin(Time.get_ticks_msec() * 0.005) + 1.0) * 0.5) * speed
	position += dir * wave
	$Sprite2D.rotation_degrees += speed * wave
