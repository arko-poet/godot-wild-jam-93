extends Node2D
#dev stage coach

var speed := 50.0
var interactRange

var hunters = []

var route #vector 2 
var lastPosition #position at time of dispatching
var isMoving

var movementTimer
var area
var InGameMain

func _ready() -> void:
	movementTimer = find_child("movementTimer")
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
		if overlaps[i].is_in_group("Collectable"): # i should make this a function in future
			InGameMain.addMoney(1)
			overlaps[i].get_parent().queue_free() #kinda jank
	
	
func dispatch(destination: Vector2): #imput a new GLOBAL destination, find route and time of route, start moving
	pass
	lastPosition = global_position
	route = (destination - global_position)
	var routeTime = route.length() / speed 
	movementTimer.start(routeTime)
	isMoving = true


func _on_movement_timer_timeout() -> void:
	pass # destination reached
	isMoving = false
