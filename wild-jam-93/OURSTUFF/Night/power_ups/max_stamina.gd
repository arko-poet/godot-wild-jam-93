extends Node2D

var inGameNightMain
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameNightMain = find_parent("InGameNightMain")
	timer.start(.1)
	for i in inGameNightMain.stageCoaches:
		i.stamina = Camp.MAX_STAMINA


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	queue_free()
