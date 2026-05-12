extends Node2D

var decayTimer
@onready var interactTimer = $interactTimer
var inGameMain
var inGameNightMain

var interactingStagecoach

var dispatchDescription := "hunt speed =  10/hunters. Reward 1$"
var dispatchIcon = "res://OURSTUFF/resources/DevStarAtlas.tres" #path of icon

func _ready() -> void:
	decayTimer = find_child("decayTimer")
	inGameMain = find_parent("InGameMain")
	inGameNightMain = find_parent("InGameNightMain")
	
	decayTimer.start(randf_range(15, 20))

func _on_decay_timer_timeout() -> void:
	inGameNightMain.deleteInteractable(self)

func stagecoachInteractStart(stagecoach: StageCoach):
	pass
	interactingStagecoach = stagecoach
	var hunters = interactingStagecoach.getStagecoachData()["hunters"]
	interactTimer.start(12 / (hunters.size() + 1))
	print(interactTimer.time_left)

func getInteractableData():
	return {
		"dispatchDescription": dispatchDescription,
		"dispatchIcon": dispatchIcon
	}

func stagecoachInteractComplete():
	interactingStagecoach.interactComplete()
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

func stopDecayTimer():
	decayTimer.stop()
	print(decayTimer.is_stopped())


func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	stagecoachInteractComplete()
