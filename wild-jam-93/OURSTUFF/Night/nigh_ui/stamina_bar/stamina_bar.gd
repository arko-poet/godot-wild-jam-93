extends Node2D

@onready var bar: ProgressBar = $Bar


func set_max_stamina(max_stamina: float) -> void:
	bar.max_value = max_stamina
	bar.value = bar.max_value


func update_stamina(stamina: float) -> void:
	bar.value = stamina
