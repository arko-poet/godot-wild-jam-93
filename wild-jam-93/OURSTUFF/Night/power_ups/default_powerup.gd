class_name PowerUp extends StagecoachInteractable

signal bounty_completed(success: bool, p_position: Vector2)
signal bounty_expired(p_position: Vector2)
signal powerup_clicked(powerup: PowerUp)

const strobeCurve = preload("res://OURSTUFF/resources/powerupStrobeCurve.tres")

const powerUpSprite0 = preload("res://OURSTUFF/resources/powerup0.tres")
const powerUpSprite1 = preload("res://OURSTUFF/resources/powerup1.tres")
const powerUpSprite2 = preload("res://OURSTUFF/resources/powerup2.tres")
const powerUpSprite3 = preload("res://OURSTUFF/resources/powerup3.tres")

const horsePill = preload("res://OURSTUFF/Night/power_ups/horse_pill.tscn")
const maxStamina = preload("res://OURSTUFF/Night/power_ups/max_stamina.tscn")
const freeMoney = preload("res://OURSTUFF/Night/power_ups/free_money.tscn")
const starShower = preload("res://OURSTUFF/Night/power_ups/star_shower.tscn")

var interactTimer
var decayTimer
var pointLightTimer

var pointLight

var interaction_time = 0.1

var inGameNightMain
var inGameMain

var powerUpType := 0
var powerUpDescription := ""


@onready var star_time_bar: Node2D = $StarTimeBar
#@onready var bounty_progress_label: Label = $BountyProgressLabel
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D



func _ready() -> void:
	decayTimer = find_child("decayTimer")
	interactTimer = find_child("interactTimer")
	pointLightTimer = find_child("pointLightTimer")
	pointLight = find_child("PointLight2D")
	inGameMain = find_parent("InGameMain")
	inGameNightMain = find_parent("InGameNightMain")
	powerUpType = randi_range(0, 3)
	match powerUpType:
		0: 
			dispatchIcon = powerUpSprite0.get_path()
			sprite.texture = powerUpSprite0
			powerUpDescription = "Horse Pills"
		1:
			dispatchIcon = powerUpSprite1.get_path()
			sprite.texture = powerUpSprite1
			powerUpDescription = "Max Stamina"
		2:
			dispatchIcon = powerUpSprite2.get_path()
			sprite.texture = powerUpSprite2
			powerUpDescription = "Free Money"
		3:
			dispatchIcon = powerUpSprite3.get_path()
			sprite.texture = powerUpSprite3
			powerUpDescription = "Star Shower"
	
	# TODO this shouild probably be just integer, ui handles how reward is displayed
	dispatchTitle = "Power Up"
	
	var decay_time := 10.0
	star_time_bar.set_decay_time(decay_time)
	decayTimer.start(decay_time)
	
	star_time_bar.reparent(inGameNightMain.dispatchUiLayer)

func _process(delta: float) -> void:
	var percentDone =  1.0 - (pointLightTimer.time_left / pointLightTimer.wait_time)
	pointLight.energy = (strobeCurve.sample(percentDone) * 2.5)
	star_time_bar.update_time_left(decayTimer.time_left)

func stagecoachInteractStart(stagecoach: StageCoach):
	pass
	interactingStagecoach = stagecoach
	interactTimer.start(interaction_time)
	print(interactTimer.time_left)

func _draw() -> void:
	if selected:
		draw_circle(
				Vector2(0, 0),
				max(collision_shape_2d.shape.size.x, collision_shape_2d.shape.size.y) / 2,
				Color.DARK_ORCHID,
				false,
				4.0,
		)

func _on_decay_timer_timeout() -> void:
	bounty_expired.emit(global_position)
	star_time_bar.queue_free()
	inGameNightMain.deleteInteractable(self)

func stagecoachInteractComplete():
	pass # spawn power up actual
	match powerUpType:
		0:
			var temp = horsePill.instantiate()
			inGameNightMain.add_child(temp)
		1:
			var temp = maxStamina.instantiate()
			inGameNightMain.add_child(temp)
		2:
			var temp = freeMoney.instantiate()
			inGameNightMain.add_child(temp)
		3:
			var temp = starShower.instantiate()
			inGameNightMain.add_child(temp)
	#delet self
	inGameNightMain.deleteInteractable(self)
	interactingStagecoach.interactComplete()

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

func getInteractableData():
	return {
		"dispatchDescription": dispatchDescription,
		"dispatchIcon": dispatchIcon,
		"dispatchTitle": dispatchTitle
		
	}

func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	
	stagecoachInteractComplete()

func _update_bounty_progress_label() -> void:
	pass

func updateFailChance(hunters: Array):
	pass

func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		powerup_clicked.emit(self)
