extends Node2D

var inGameNightMain
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameNightMain = find_parent("InGameNightMain")
	inGameNightMain.starSpawnHighRoll = 3.0
	inGameNightMain.starSpawnLowRoll = 1.0
	timer.start(30)
	


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	inGameNightMain.starSpawnHighRoll = 7.0
	inGameNightMain.starSpawnLowRoll = 3.0
	queue_free()
