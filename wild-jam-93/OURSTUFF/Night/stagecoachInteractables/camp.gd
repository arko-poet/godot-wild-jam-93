class_name Camp extends StagecoachInteractable

const MAX_STAMINA := 15.0

@onready var campTexture = "res://OURSTUFF/resources/DevCampAtlas.tres"

@onready var interactTimer = $interactTimer
@onready var sprite = $Sprite2D

var inGameMain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameMain = find_parent("InGameMain")
	dispatchDescription = "Refill Stamina"
	dispatchIcon = campTexture
	dispatchTitle = "Refill"

func stagecoachInteractStart(stagecoach: StageCoach): # the result of a stagecoach interacting
	pass #input stage coach, get array of hunters, this would decide how interaction would go like length of time or fail chance
	interactingStagecoach = stagecoach
	interactingStagecoach.isAtCamp = true
	interactTimer.start(0.1)
	print(stagecoach.isInteracting)
	
func stagecoachInteractComplete(): # called when stagecoach finishes interaciton timer
	pass 
	interactingStagecoach.stamina = MAX_STAMINA
	for i in interactingStagecoach.bounties:
		inGameMain.addMoney(i.reward)
		print(i.reward)
	interactingStagecoach.bounties = []
	
	#heal hunters
	for h: Hunter in interactingStagecoach.hunters:
		h.state = Hunter.State.BUSY
	
	interactingStagecoach.interactComplete()
	

func canInteract(stagecoach: StageCoach): #check data and return true if all requirments are met 
	var data = stagecoach.getStagecoachData()
	if true:
		return true
	else:
		return false


func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	stagecoachInteractComplete()
