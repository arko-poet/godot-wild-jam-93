extends StagecoachInteractable 

signal bounty_completed(success: bool, p_position: Vector2)
signal bounty_expired(p_position: Vector2)

var decayTimer
var interaction_time: float
@onready var interactTimer = $interactTimer
var inGameMain
var inGameNightMain

var bounty: Bounty
var failChance

@onready var star_time_bar: Node2D = $TimerBar
@onready var bounty_progress_label: Label = $BountyProgressLabel
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	decayTimer = find_child("decayTimer")
	inGameMain = find_parent("InGameMain")
	inGameNightMain = find_parent("InGameNightMain")
	
	bounty = Bounty.new()
	bounty.difficulty = randi_range(1, 5)
	bounty.reward = randi_range(50, 150) * bounty.difficulty
	
	# TODO this shouild probably be just integer, ui handles how reward is displayed
	dispatchDescription = "Reward $%s" % bounty.difficulty
	dispatchIcon = "res://OURSTUFF/resources/DevStarAtlas.tres" #path of icon
	dispatchTitle = "Bounty"
	
	var decay_time := randf_range(15, 20)
	star_time_bar.set_decay_time(decay_time)
	decayTimer.start(decay_time)
	

func _process(_delta: float) -> void:
	# NOTE if this is too expensive computationally we can create extra timer that will update periodically instead
	star_time_bar.update_time_left(decayTimer.time_left)
	
	if not interactTimer.is_stopped():
		_update_bounty_progress_label()


func _on_decay_timer_timeout() -> void:
	bounty_expired.emit(global_position)
	inGameNightMain.deleteInteractable(self)

func stagecoachInteractStart(stagecoach: StageCoach):
	pass
	interactingStagecoach = stagecoach
	var hunters = interactingStagecoach.getStagecoachData()["hunters"]
	interaction_time = 12 / (hunters.size() + 1)
	interactTimer.start(interaction_time)
	print(interactTimer.time_left)
	
	bounty_progress_label.show()

func getInteractableData():
	return {
		"dispatchDescription": dispatchDescription,
		"dispatchIcon": dispatchIcon,
		"dispatchTitle": dispatchTitle
		
	}

func stagecoachInteractComplete():
	var failRoll = randf_range(0, 1) 
	if failChance < failRoll:
		interactingStagecoach.interactComplete()
		interactingStagecoach.bounties.append(bounty)
		inGameNightMain.deleteInteractable(self)
		bounty_completed.emit(true, global_position)
	else:
		bounty_completed.emit(false, global_position)
		interactingStagecoach.interactComplete()
		inGameNightMain.deleteInteractable(self)
		
		# hunter injuries
		for h in interactingStagecoach.hunters:
			h.state = Hunter.State.UNAVAILABLE
			
	

func canInteract(stagecoach: StageCoach): #check if stagecoach is able to interact
	pass
	var data = stagecoach.getStagecoachData()
	print(data)
	var temp = (global_position - stagecoach.global_position).length() / stagecoach.speed
	if (data["isInteracting"] == false) && data["stamina"] > temp:
		return true
	else:
		return false

func stopDecayTimer():
	decayTimer.set_paused(true)
	star_time_bar.hide()
	print(decayTimer.is_stopped())

func startDecayTimer():
	decayTimer.set_paused(false)
	star_time_bar.show()


func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	
	stagecoachInteractComplete()
	


func _update_bounty_progress_label() -> void:
	bounty_progress_label.text = "%s%%" % int(((interaction_time - interactTimer.time_left) / interaction_time)* 100) 

func updateFailChance(hunters: Array):
	var power := 0
	for h in hunters:
		if h.state != Hunter.State.UNAVAILABLE:
			power += h.power
	if power > bounty.difficulty:
		failChance = 0.0
	elif power == 0:
		failChance = 1.0
	else: # power <= difficulty
		failChance = max(0.0, 0.1 * (1 + bounty.difficulty - power))
