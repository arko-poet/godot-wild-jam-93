class_name Camp extends StagecoachInteractable

signal camp_clicked(camp: Camp)

const MAX_STAMINA := 30.0
const floatingText = preload("res://OURSTUFF/Night/nigh_ui/floating_text/floating_text.tscn")

var selection_highligh_enabled = false

@onready var campTexture = "res://OURSTUFF/resources/DevCampAtlas.tres"

@onready var interactTimer = $interactTimer
@onready var sprite = $Sprite2D
@onready var money_sound: AudioStreamPlayer2D = $MoneySound
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


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


func _draw() -> void:
	print(selected)
	if selected and selection_highligh_enabled:
		draw_circle(
				Vector2(0, 0),
				collision_shape_2d.shape.radius,
				Color.DARK_ORCHID,
				false,
				4.0,
		)


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
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	sprite.scale = sign_post_scale
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		camp_clicked.emit(self)


func _on_timer_timeout() -> void:
	selection_highligh_enabled = !selection_highligh_enabled
	queue_redraw()
