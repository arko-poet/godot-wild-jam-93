extends Node2D

@onready var timer_progress: ProgressBar = $TimerProgress
@onready var timer_label: Label = $TimerProgress/TimerLabel


func set_decay_time(decay_time: float) -> void:
	timer_progress.max_value = decay_time
	_update_timer_label(decay_time)


func update_time_left(time_left: float) -> void:
	timer_progress.value = time_left
	_update_timer_label(time_left)
	

func _update_timer_label(time: float) -> void:
	var minutes := int(time / 60.0)
	var seconds := int(time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
