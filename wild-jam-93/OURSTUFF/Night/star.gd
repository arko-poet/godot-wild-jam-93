extends Node2D

var decayTimer

func _ready() -> void:
	decayTimer = find_child("decayTimer")
	
	decayTimer.start(randf_range(15, 20))

func _on_decay_timer_timeout() -> void:
	queue_free()
