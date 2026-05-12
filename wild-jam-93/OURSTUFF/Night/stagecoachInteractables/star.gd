extends StagecoachInteractable 

var decayTimer
@onready var interactTimer = $interactTimer
var inGameMain
var inGameNightMain

var interactingStagecoach

@onready var star_time_bar: Node2D = $TimerBar


func _ready() -> void:
	decayTimer = find_child("decayTimer")
	inGameMain = find_parent("InGameMain")
	inGameNightMain = find_parent("InGameNightMain")
	
	# TODO this shouild probably be just integer, ui handles how reward is displayed
	dispatchDescription = "Reward 1$"
	dispatchIcon = "res://OURSTUFF/resources/DevStarAtlas.tres" #path of icon
	
	var decay_time := randf_range(15, 20)
	star_time_bar.set_decay_time(decay_time)
	decayTimer.start(decay_time)
	

func _process(_delta: float) -> void:
	# NOTE if this is too expensive computationally we can create extra timer that will update periodically instead
	star_time_bar.update_time_left(decayTimer.time_left)


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
