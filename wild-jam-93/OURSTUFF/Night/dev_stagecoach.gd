extends Node2D
#dev stage coach

var speed := 50.0
var interactRange

var hunters = [null, null, null, null]
var upgrades = [] #non stat based upgrades

var route #vector 2 
var lastPosition #position at time of dispatching
var isMoving := false
var isInteracting := false

var movementTimer
var interactTimer
var area
var InGameMain

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

func _physics_process(delta: float) -> void:
	pass #check for overlapping areas (stars)
	var overlaps = area.get_overlapping_areas()
	for i in overlaps.size():
		if overlaps[i].is_in_group("StagecoachInteractable"): 
			interact(overlaps[i].get_parent())
	
	
func dispatch(destination: Vector2): #imput a new GLOBAL destination, find route and time of route, start moving
	pass
	if !isInteracting:
		lastPosition = global_position
		route = (destination - global_position)
		var routeTime = route.length() / speed 
		movementTimer.start(routeTime)
		isMoving = true

func _on_movement_timer_timeout() -> void:
	pass # destination reached
	isMoving = false

func _on_interact_timer_timeout() -> void:
	pass # Replace with function body.
	isInteracting = false

func interact(node: Node2D):
	pass #call interact function on node if possible
	if !isInteracting:
		if node.canInteract(self): 
			node.stagecoachInteract()
			isInteracting = true
			isMoving = false
			movementTimer.stop()
			interactTimer.start(7)

func getStagecoachData():
	var data = {
		"isMoving": isMoving,
		"isInteracting": isInteracting
	}
	
	return data
