extends Node2D

const STAR_TEST = preload("uid://btupxbstxpk2g")

var timer = 0.0

func _process(delta: float) -> void:

	timer += delta
	if timer > 1:
		timer = 0
		var star = STAR_TEST.instantiate()
		
		star.global_position = Vector2(randf_range(10, get_viewport_rect().size.x - 10), -10) #Spawn position above screen
		star.target = Vector2(randf_range(10, get_viewport_rect().size.x - 10), randf_range(10, get_viewport_rect().size.y - 10)) #target position inside screen with small margin

		add_child(star)
