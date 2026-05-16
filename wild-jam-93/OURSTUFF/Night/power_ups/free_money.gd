extends Node2D

var inGameMain
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameMain = find_parent("InGameNightMain")
	timer.start(0.1)
	inGameMain.addMoney(randi_range(1000, 2000))


func _on_timer_timeout() -> void:
	pass # Replace with function body.

	queue_free()
