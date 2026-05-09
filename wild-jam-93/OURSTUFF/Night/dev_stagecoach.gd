extends Node2D
#dev stage coach

var speed := 50.0
var interactRange
var hunters = []
var route #vector 2 
var lastPosition #position at time of dispatching
var isMoving
var movementTimer

func _ready() -> void:
	movementTimer = find_child("movementTimer")

func _process(delta: float) -> void:
	if isMoving:
		pass
		var timerPercentDone = (movementTimer.wait_time - movementTimer.time_left) / movementTimer.wait_time
		
		position = lastPosition + (timerPercentDone * route)


func dispatch(destination: Vector2): #imput a new GLOBAL destination, find route and time of route
	pass
	lastPosition = global_position
	route = (destination - global_position)
	var routeTime = route.length() / speed 
	movementTimer.start(routeTime)
	isMoving = true


func _on_movement_timer_timeout() -> void:
	pass # destination reached
	isMoving = false
