extends CanvasModulate

@export var gradient_time: Gradient


func updateColor(ratio: float):
	color = gradient_time.sample(ratio)
