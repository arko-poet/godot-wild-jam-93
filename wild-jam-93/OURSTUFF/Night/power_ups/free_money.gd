extends Node2D

var inGameMain
@onready var timer: Timer = $Timer
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameMain = find_parent("InGameMain")
	timer.start(0.1)
	inGameMain.addMoney(randi_range(1000, 2000))
	sfx.play()


func _on_timer_timeout() -> void:
	pass # Replace with function body.

	queue_free()
