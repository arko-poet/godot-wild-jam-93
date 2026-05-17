extends Node2D
class_name ThumbleWheels

var dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
var lifetime: float = randf_range(3, 5)
var speed = randf_range(2, 4)
var rand_wave_pos = randi()
func _ready() -> void:
	global_position = Vector2(randf_range(50, get_viewport_rect().size.x-50), randf_range(50, get_viewport_rect().size.y - 50))

	
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		modulate.a -= 0.02
	
	if modulate.a <= 0:
		queue_free()
	
	
	var t = Time.get_ticks_msec() * 0.002 + rand_wave_pos

	var wave = ((sin(t)+1)*0.5 * 0.8 + (sin(t * 1.5)+1)*0.5 * 0.2) * speed 
	position += dir * wave
	$Sprite2D.rotation_degrees += wave * sign(dir.x) * 5

	var noise_x = sin(t * 4.0 + cos(t * 2))
	var noise_y = cos(t * 4.0 + sin(t * 2))
	$Sprite2D.position = dir.orthogonal() * (noise_x + noise_y) * speed * 0.5
