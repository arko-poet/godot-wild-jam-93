extends Node2D
#this script is in charge of everything involved during the night section of the game
 
var Camp #camp scene
var stageCoach = preload("res://OURSTUFF/Night/dev_stagecoach.tscn") #stage coach scene
var star = preload("res://OURSTUFF/Night/star.tscn") #star scene

@export var stageCoachSelectionRange := 50.0

var stageCoaches = [] #array of all stagecoaches
var selectedStageCoach

var starSpawnTimer

func _ready() -> void:
	starSpawnTimer = find_child("starSpawnTimer")
	starSpawnTimer.start(.1)
	
	
	for i in 4: #temporary
		var temp = stageCoach.instantiate()
		var newPosition = Vector2(randf_range(0, 1000), randf_range(0, 1000))
		temp.global_position = newPosition
		stageCoaches.append(temp)
		add_child(temp)

func _process(delta: float) -> void:
	
	#input detection
	if Input.is_action_just_pressed("mousePrimary"):
		pass
		if selectedStageCoach == null:
			selectStageCoach()
		else:
			dispatchStageCoach()
	elif Input.is_action_just_pressed("mouseSecondary"):
		selectedStageCoach = null

func spawnStar(): #spawn star
	var temp = star.instantiate()
	temp.position = Vector2(randf_range(0, 1000), randf_range(0, 1000))
	add_child(temp)

func selectStageCoach():
	pass #attempt to select coach at mouse position, if one exists
	for i in stageCoaches.size():
		var distance = (get_global_mouse_position() - stageCoaches[i].global_position).length()
		if distance <= stageCoachSelectionRange:
			selectedStageCoach = stageCoaches[i]
			print(" selected")
			break
		else: 
			print(i, " not in range")

func dispatchStageCoach():
	pass #send selected coach to mouse position
	selectedStageCoach.dispatch(get_global_mouse_position())
	selectedStageCoach = null
	print(" dispatched")


func _on_star_spawn_timer_timeout() -> void:
	pass # Replace with function body.
	spawnStar()
