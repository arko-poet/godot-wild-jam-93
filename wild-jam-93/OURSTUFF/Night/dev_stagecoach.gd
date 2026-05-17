class_name StageCoach extends Node2D
#dev stage coach

var speed := 50.0
var interactRange
var stageCoachScale := scale

var hunters: Array[Hunter] = []
var upgrades = [] #non stat based upgrades
var bounties = []
var stamina := Camp.MAX_STAMINA: # how many seconds of travel the stagecoach has left
	set(value):
		stamina = value
		if stamina_bar:
			stamina_bar.position = position + stamina_bar_offset
			stamina_bar.update_stamina(stamina)
var stamina_bar_offset: Vector2
var route #vector 2 
var interactingNode
var pausedNode
var pausedTime
var lastPosition #position at time of dispatching
var isMoving := false
var isInteracting := false
var isAtCamp := true:
	set(value):
		isAtCamp = value
		for h in hunters:
			h.at_camp = value

var movementTimer

var InGameMain

var ui_layer: CanvasLayer

var selected := false:
	set(value):
		if value == true:
			horse_sound.play()
		selected = value
		queue_redraw()

#@onready var sprite = $Sprite2D
@onready var stamina_bar: Node2D = $StaminaBar
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var stage_coach_animation: StagecoachAnimation = $StageCOachAnimation
@onready var pointLight: PointLight2D = $PointLight2D
@onready var lightTimer: Timer = $lightTimer
@onready var horse_sound: AudioStreamPlayer2D = $HorseSound
@onready var dirtParticles: CPUParticles2D = $StageCOachAnimation/CPUParticles2D


func _ready() -> void:
	movementTimer = find_child("movementTimer")
	InGameMain = find_parent("InGameMain")
	stamina_bar.set_max_stamina(Camp.MAX_STAMINA)
	stamina_bar_offset = stamina_bar.position
	
	# need to put it to ui_layer, otherwise it get shaded by canvas modulate
	stamina_bar.reparent(ui_layer)
	

func _process(delta: float) -> void:
	if isMoving: # move
		pass
		dirtParticles.emitting = true
		stage_coach_animation.animate(route.normalized())
		var timerPercentDone = (movementTimer.wait_time - movementTimer.time_left) / movementTimer.wait_time
		
		position = lastPosition + (timerPercentDone * route)
		stamina -= delta
	else:
		dirtParticles.emitting = false


func _draw() -> void:
	if selected:
		draw_circle(
				Vector2(0, 0),
				max(collision_shape_2d.shape.size.x, collision_shape_2d.shape.size.y) / 3.5,
				Color.AQUA,
				false,
				4.0,
		)


func dispatch(node: StagecoachInteractable): #imput a new interacrable node, find route and time of route, start moving
	pass
	isAtCamp = false
	interactingNode = node
	
	var destination = interactingNode.global_position
	if interactingNode is Camp:
		var temp = (destination - global_position).normalized() * 100
		destination -= temp
	if !isInteracting:
		
		if pausedNode != null:
			pausedNode.startDecayTimer()
		lastPosition = global_position
		route = (destination - global_position)
		var routeTime = route.length() / speed 
		
		movementTimer.start(routeTime)
		isMoving = true
		pausedNode = interactingNode

func interactStart(): #called when stagecoach reaches destinatino
	pass
	var data = interactingNode.getInteractableData() 
	pausedNode = null
	isMoving = false
	interactingNode.stagecoachInteractStart(self)
	isInteracting = true
	#movementTimer.stop()

func interactComplete(): #called by interactable when interaciton finished
	pass
	isInteracting = false
	print("ASS")

func _on_movement_timer_timeout() -> void:
	pass # destination reached
	interactStart()


func getStagecoachData():
	var data = {
		"isMoving": isMoving,
		"isInteracting": isInteracting,
		"hunters": hunters,
		"stamina": stamina
		}
	return data

func setStagecoachData(data: Dictionary): #call this on stagecoach scene when it is spawned
	isMoving = data["isMoving"]
	isInteracting = data["isInteracting"]
	hunters = data["hunters"]
	stamina = data["stamina"]

func assignHunters(newHunters: Array): #called by the ingamenightmain when dispatched
	hunters = newHunters

func setSpriteScale(new_scale: float):
	for i in stage_coach_animation.sprites:
		i.scale = Vector2(new_scale, new_scale)

func _on_area_2d_mouse_entered() -> void:
	scale = stageCoachScale * 1.1
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	scale = stageCoachScale
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_light_timer_timeout() -> void:
	pass # Replace with function body.
	pointLight.energy = 2.5
	scale = stageCoachScale
