class_name StageCoach extends Node2D
#dev stage coach

var speed := 50.0
var interactRange

var hunters = [null, null, null, null]
var upgrades = [] #non stat based upgrades

var route #vector 2 
var interactingNode
var lastPosition #position at time of dispatching
var isMoving := false
var isInteracting := false

var movementTimer
var interactTimer
var area
var InGameMain
@onready var sprite = $Sprite2D


func _ready() -> void:
	movementTimer = find_child("movementTimer")
	interactTimer = find_child("interactTimer")
	area = find_child("stageCoachArea")
	InGameMain = find_parent("InGameMain")

func _process(delta: float) -> void:
	if isMoving: # move
		pass
		var timerPercentDone = (movementTimer.wait_time - movementTimer.time_left) / movementTimer.wait_time
		
		position = lastPosition + (timerPercentDone * route)


func dispatch(node: Node2D): #imput a new interacrable node, find route and time of route, start moving
	pass
	interactingNode = node
	var destination = interactingNode.global_position
	if !isInteracting:
		lastPosition = global_position
		route = (destination - global_position)
		var routeTime = route.length() / speed 
		area.rotation = route.angle()
		sprite.rotation = route.angle()
		
		movementTimer.start(routeTime)
		isMoving = true

func _on_movement_timer_timeout() -> void:
	pass # destination reached
	var data = interactingNode.getInteractableData() 
	
	isMoving = false
	interactingNode.stagecoachInteractStart()
	isInteracting = true
	movementTimer.stop()
	interactTimer.start(7)

func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	isInteracting = false
	
	interactingNode.stagecoachInteractComplete()

func getStagecoachData():
	var data = {
		"isMoving": isMoving,
		"isInteracting": isInteracting
	}
	return data

func setStagecoachData(data: Dictionary): #call this on stagecoach scene when it is spawned
	isMoving = data["isMoving"]
	isInteracting = data["isInteracting"]
