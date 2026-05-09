extends Node2D

var decayTimer
var inGameMain

func _ready() -> void:
	decayTimer = find_child("decayTimer")
	inGameMain = find_parent("InGameMain")
	
	decayTimer.start(randf_range(15, 20))

func _on_decay_timer_timeout() -> void:
	queue_free()

func stagecoachInteract(): # perfom interaction 
	pass
	inGameMain.addMoney(1)
	queue_free()

func canInteract(stagecoach: Node2D): #check if stagecoach is able to interact
	pass
	var data = stagecoach.getStagecoachData()
	print(data)
	if data["isInteracting"] == false:
		return true
	else:
		return false
