extends Node2D

var decayTimer
var inGameMain
var inGameNightMain

func _ready() -> void:
	decayTimer = find_child("decayTimer")
	inGameMain = find_parent("InGameMain")
	inGameNightMain = find_parent("InGameNightMain")
	
	decayTimer.start(randf_range(15, 20))

func _on_decay_timer_timeout() -> void:
	inGameNightMain.deleteInteractable(self)

func stagecoachInteractStart():
	pass

func getInteractableData():
	return {}

func stagecoachInteractComplete():
	inGameMain.addMoney(1)
	inGameNightMain.deleteInteractable(self)

func canInteract(stagecoach: Node2D): #check if stagecoach is able to interact
	pass
	var data = stagecoach.getStagecoachData()
	print(data)
	if data["isInteracting"] == false:
		return true
	else:
		return false
