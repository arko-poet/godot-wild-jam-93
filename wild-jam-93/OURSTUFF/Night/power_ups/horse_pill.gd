extends Node2D

var inGameNightMain
@onready var timer: Timer = $Timer
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameNightMain = find_parent("InGameNightMain")
	timer.start(20)
	sfx.play()
	for i in inGameNightMain.stageCoaches:
		i.speed = 120.0


func _on_timer_timeout() -> void:
	pass # Replace with function body.
	for i in inGameNightMain.stageCoaches:
		i.speed = 50.0
	queue_free()
