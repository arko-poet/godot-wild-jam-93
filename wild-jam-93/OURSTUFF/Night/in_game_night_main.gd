extends Node2D
#this script is in charge of everything involved during the night section of the game
 
var Camp #camp scene
const stageCoach = preload("res://OURSTUFF/Night/dev_stagecoach.tscn") #stage coach scene
const star = preload("res://OURSTUFF/Night/stagecoachInteractables/star.tscn") #star scene

@export var selectionRange := 50.0

var stageCoaches = [] #array of all stagecoaches
var interactables = [] #array of stagecoach interactables
var selectedStageCoach
var selectedInteractable

var starSpawnTimer

func _ready() -> void:
	starSpawnTimer = find_child("starSpawnTimer")
	starSpawnTimer.start(1)
	
	
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
		if selectedInteractable == null:
			selectInteractable()
		
	elif Input.is_action_just_pressed("mouseSecondary"):
		selectedStageCoach = null
		selectedInteractable = null
		# can also be deselected via ui
	
	if Input.is_action_just_pressed("dev1"):
		dispatchStagecoach()

#func spawnStar(): #spawn star OLD
#	var temp = star.instantiate()
#	temp.position = Vector2(randf_range(0, 1000), randf_range(0, 1000))
#	add_child(temp)

func selectStageCoach():
	pass #attempt to select coach at mouse position, if one exists
	#right now you can select a moving coach and divert it, but that cna change
	for i in stageCoaches.size():
		var distance = (get_global_mouse_position() - stageCoaches[i].global_position).length()
		if distance <= selectionRange:
			selectedStageCoach = stageCoaches[i]
			#highlight coach or something
			print("selected")
			break

func selectInteractable():
	pass #attempt to select anyinteractable
	for i in interactables.size():
		if interactables[i] != null: #jank. check in any null values in array and delete
			var distance = (get_global_mouse_position() - interactables[i].global_position).length()
			if distance <= selectionRange:
				selectedInteractable = interactables[i]
				#call a function to spawn ui element here
				print("selected")
				break
		else:
			interactables.remove_at(i)



func dispatchStagecoach(): # called by the ui when player clicks dispatch
	if (selectedInteractable != null) && (selectedStageCoach != null):
		if selectedInteractable.canInteract(selectedStageCoach) == true:
			interactables.erase(selectedInteractable)
			selectedStageCoach.dispatch(selectedInteractable)
			selectedInteractable = null
			selectedStageCoach = null
			print("dispatched")



func _on_star_spawn_timer_timeout() -> void:
	pass # Replace with function body.
	spawnInteractable(GlobalEnums.spawnables.STAR, Vector2(randf_range(0,1000), randf_range(0,1000)))

func spawnInteractable(type: GlobalEnums.spawnables, location: Vector2): #controls spawning of stars, objects, locations etc
	pass
	match type:
		GlobalEnums.spawnables.STAR:
			var temp =  star.instantiate()
			temp.global_position = location
			interactables.append(temp)
			add_child(temp)

func deleteInteractable(node: Node2D):
	interactables.erase(node)
	node.queue_free()
