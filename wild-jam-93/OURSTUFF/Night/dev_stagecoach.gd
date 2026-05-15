class_name StageCoach extends Node2D
#dev stage coach

var speed := 50.0
var interactRange
var stageCoachScale := .5

var hunters: Array[Hunter] = []
var upgrades = [] #non stat based upgrades
var bounties = []
var stamina := Camp.MAX_STAMINA: # how many seconds of travel the stagecoach has left
	set(value):
		stamina = value
		if stamina_bar:
			stamina_bar.position = position
			stamina_bar.update_stamina(stamina)
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
		selected = value
		queue_redraw()

#@onready var sprite = $Sprite2D
@onready var stamina_bar: Node2D = $StaminaBar
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var stage_coach_animation: StagecoachAnimation = $StageCOachAnimation

func _ready() -> void:
	movementTimer = find_child("movementTimer")
	InGameMain = find_parent("InGameMain")
	stamina_bar.set_max_stamina(Camp.MAX_STAMINA)
	
	# need to put it to ui_layer, otherwise it get shaded by canvas modulate
	stamina_bar.reparent(ui_layer)
	

func _process(delta: float) -> void:
	if isMoving: # move
		pass
		stage_coach_animation.animate(route.normalized())
		var timerPercentDone = (movementTimer.wait_time - movementTimer.time_left) / movementTimer.wait_time
		
		position = lastPosition + (timerPercentDone * route)
		stamina -= delta


func _draw() -> void:
	if selected:
		draw_circle(
				Vector2(0, 0),
				max(collision_shape_2d.shape.size.x, collision_shape_2d.shape.size.y) / 2,
				Color.AQUA,
				false,
				4.0,
		)


func dispatch(node: StagecoachInteractable): #imput a new interacrable node, find route and time of route, start moving
	pass
	isAtCamp = false
	interactingNode = node
	var destination = interactingNode.global_position
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
	scale = Vector2(.6, .6)


func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(stageCoachScale, stageCoachScale)
