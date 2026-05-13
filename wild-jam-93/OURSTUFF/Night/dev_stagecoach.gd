class_name StageCoach extends Node2D
#dev stage coach

var speed := 50.0
var interactRange

var hunters = []
var upgrades = [] #non stat based upgrades
var stamina := Camp.MAX_STAMINA # how many seconds of travel the stagecoach has left

var route #vector 2 
var interactingNode
var pausedNode
var pausedTime
var lastPosition #position at time of dispatching
var isMoving := false
var isInteracting := false
var isAtCamp := true

var movementTimer

var InGameMain
@onready var sprite = $Sprite2D
@onready var stamina_bar: Node2D = $StaminaBar


func _ready() -> void:
	movementTimer = find_child("movementTimer")
	InGameMain = find_parent("InGameMain")
	stamina_bar.set_max_stamina(Camp.MAX_STAMINA)

func _process(delta: float) -> void:
	if isMoving: # move
		pass
		var timerPercentDone = (movementTimer.wait_time - movementTimer.time_left) / movementTimer.wait_time
		
		position = lastPosition + (timerPercentDone * route)
		stamina -= delta
		print(stamina)
		stamina_bar.update_stamina(stamina)


func dispatch(node: StagecoachInteractable): #imput a new interacrable node, find route and time of route, start moving
	pass
	interactingNode = node
	var destination = interactingNode.global_position
	if !isInteracting:
		
		if pausedNode != null:
			pausedNode.startDecayTimer()
		lastPosition = global_position
		route = (destination - global_position)
		var routeTime = route.length() / speed 
		sprite.rotation = route.angle()
		
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
