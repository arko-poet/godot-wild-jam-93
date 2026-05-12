class_name StageCoach extends Node2D
#dev stage coach

var speed := 50.0
var interactRange

var hunters = []
var upgrades = [] #non stat based upgrades
var stamina: int ## how much distance can it travel etc. need to decide how it works

var route #vector 2 
var interactingNode
var lastPosition #position at time of dispatching
var isMoving := false
var isInteracting := false
var isAtCamp := true

var movementTimer

var InGameMain
@onready var sprite = $Sprite2D


func _ready() -> void:
	movementTimer = find_child("movementTimer")
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
		sprite.rotation = route.angle()
		
		movementTimer.start(routeTime)
		isMoving = true

func interactStart(): #called when stagecoach reaches destinatino
	pass
	var data = interactingNode.getInteractableData() 
	
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
		"hunters": hunters
	}
	return data

func setStagecoachData(data: Dictionary): #call this on stagecoach scene when it is spawned
	isMoving = data["isMoving"]
	isInteracting = data["isInteracting"]
	hunters = data["hunters"]

func assignHunters(newHunters: Array): #called by the ingamenightmain when dispatched
	hunters = newHunters
