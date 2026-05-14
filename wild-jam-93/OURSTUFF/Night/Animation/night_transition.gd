extends CanvasModulate

@export var gradient_time: Gradient

## How long the night last in second
var night_time = 60.0
var current_time: float = 0.0

func _process(delta: float) -> void:
	current_time += delta
	
	var ratio_in_game_time = current_time/night_time
	
	color = gradient_time.sample(ratio_in_game_time)
