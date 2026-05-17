class_name Camp extends StagecoachInteractable

const MAX_STAMINA := 30.0
const floatingText = preload("res://OURSTUFF/Night/nigh_ui/floating_text/floating_text.tscn")

@onready var campTexture = "res://OURSTUFF/resources/DevCampAtlas.tres"

@onready var interactTimer = $interactTimer
@onready var sprite = $Sprite2D
@onready var money_sound: AudioStreamPlayer2D = $MoneySound


var inGameMain
var sign_post_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	inGameMain = find_parent("InGameMain")
	dispatchDescription = "Refill Stamina"
	dispatchIcon = campTexture
	dispatchTitle = "Refill"
	
	sign_post_scale = sprite.scale

func stagecoachInteractStart(stagecoach: StageCoach): # the result of a stagecoach interacting
	pass #input stage coach, get array of hunters, this would decide how interaction would go like length of time or fail chance
	interactingStagecoach = stagecoach
	interactingStagecoach.isAtCamp = true
	interactTimer.start(0.1)
	print(stagecoach.isInteracting)
	
func stagecoachInteractComplete(): # called when stagecoach finishes interaciton timer
	pass 
	interactingStagecoach.stamina = MAX_STAMINA
	var cashEarned = 0
	for i in interactingStagecoach.bounties:
		cashEarned += i.reward
	if cashEarned > 0:
		inGameMain.addMoney(cashEarned)
		var temp = floatingText.instantiate()
		add_child(temp)
		temp.show_text("$%s" % cashEarned) 
		money_sound.play()
		#play cash register sound
	interactingStagecoach.bounties = []
	
	#heal hunters
	for h: Hunter in interactingStagecoach.hunters:
		h.state = Hunter.State.AVAILABLE
	
	interactingStagecoach.interactComplete()
	interactingStagecoach.hunters = []
	

func canInteract(stagecoach: StageCoach): #check data and return true if all requirments are met 
	var data = stagecoach.getStagecoachData()
	if true:
		return true
	else:
		return false


func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	stagecoachInteractComplete()


func _on_area_2d_mouse_entered() -> void:
	sprite.scale = sign_post_scale * 1.2


func _on_area_2d_mouse_exited() -> void:
	sprite.scale = sign_post_scale
