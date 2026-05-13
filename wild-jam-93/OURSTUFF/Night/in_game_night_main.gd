extends Node2D
#this script is in charge of everything involved during the night section of the game
 
const stageCoach = preload("res://OURSTUFF/Night/dev_stagecoach.tscn") #stage coach scene
const star = preload("res://OURSTUFF/Night/stagecoachInteractables/star.tscn") #star scene
const camp = preload("res://OURSTUFF/Night/stagecoachInteractables/camp.tscn")
#const dispatchWindow = preload("res://OURSTUFF/Night/dispatch_window/dispatch_window.tscn")
const devHunterIcon = "res://OURSTUFF/resources/devBountyHunter.png"


@export var selectionRange := 50.0
@export var overlapRange := 75

var playableArea := Vector2i(1280, 720)

var stageCoaches = [] #array of all stagecoaches
var interactables = [] #array of stagecoach interactables
var selectedStageCoach
var selectedInteractable

var inGameMain

@onready var dispatchUiLayer = $dispatchUiLayer
@onready var night_ui: NighUI = $dispatchUiLayer/NightUI
@onready var dispatch_window: DispatchWindow = $dispatchUiLayer/DispatchWindow
@onready var roundTimer = $roundTimer
@onready var starSpawnTimer = $starSpawnTimer


func _ready() -> void:
	inGameMain = find_parent("InGameMain")
	starSpawnTimer.start(1)
	roundTimer.start(60.0 * 5.0)
	spawnInteractable("camp", Vector2(0,0))


func _process(delta: float) -> void:
	
	#update ui time
	night_ui.update_time_left(int(roundTimer.time_left + 1.0))
	
	#GITHUB ASSS FUCKN YOU
	var ihateyou = 0
	
	#input detection
	if Input.is_action_just_pressed("mousePrimary"):
		pass
		if selectedStageCoach == null:
			selectStageCoach()
		elif selectedInteractable == null:
			selectInteractable()
		
	elif Input.is_action_just_pressed("mouseSecondary"):
		selectedStageCoach = null
		selectedInteractable = null
		# can also be deselected via ui
	
	if Input.is_action_just_pressed("dev1"):
		pass #dispatchStagecoach([null])

#func spawnStar(): #spawn star OLD
#	var temp = star.instantiate()
#	temp.position = Vector2(randf_range(0, 1000), randf_range(0, 1000))
#	add_child(temp)

func set_hunters(hunters: Array[Hunter]) -> void:
	for hunter in hunters:
		night_ui.add_hunter(hunter)


func selectStageCoach():
	pass #attempt to select coach at mouse position, if one exists
	#right now you can select a moving coach and divert it, but that cna change
	for i in stageCoaches.size():
		var distance = (get_global_mouse_position() - stageCoaches[i].global_position).length()
		if (distance <= selectionRange) && (stageCoaches[i].isInteracting == false):
			selectedStageCoach = stageCoaches[i]
			#highlight coach or something
			if selectedInteractable != null:
				dispatch_window.show_dispatch_panel(selectedStageCoach, selectedInteractable)
			break

func selectInteractable():
	pass #attempt to select anyinteractable
	for i in interactables.size():
		if interactables[i] != null: #jank. check in any null values in array and delete
			var distance = (get_global_mouse_position() - interactables[i].global_position).length()
			if distance <= selectionRange:
				selectedInteractable = interactables[i]
				#call a function to spawn ui element here
				if selectedStageCoach != null:
					
					dispatch_window.show_dispatch_panel(selectedStageCoach, selectedInteractable)
				break
		else:
			interactables.remove_at(i)



func dispatchStagecoach(stagecoach: StageCoach): # called by the ui when player clicks dispatch
	if (selectedInteractable != null) && (selectedStageCoach != null):
		if selectedInteractable.canInteract(selectedStageCoach) == true:
			selectedInteractable.stopDecayTimer()
			if !(selectedInteractable is Camp):
				interactables.erase(selectedInteractable)
			selectedStageCoach.dispatch(selectedInteractable)
			selectedInteractable = null
			selectedStageCoach = null
			print("dispatched")



func _on_star_spawn_timer_timeout() -> void:
	pass # Replace with function body.
	
	var isOverlaping = true
	var allClickables = stageCoaches + interactables
	var temp = Vector2(0,0)
	while(isOverlaping): # may have performance issues if large numbers
		isOverlaping = false
		temp = Vector2(randf_range(0,playableArea.x), randf_range(0,playableArea.y))
		for i in allClickables:
			print(allClickables)
			if (temp - i.global_position).length() < overlapRange:
				isOverlaping = true
				break
	
	starSpawnTimer.start(randf_range(3, 7))
	spawnInteractable("star", temp)

func spawnInteractable(type: String, location: Vector2): #controls spawning of stars, objects, locations etc
	pass
	match type:
		"star":
			var temp =  star.instantiate()
			temp.global_position = location
			interactables.append(temp)
			add_child(temp)
		"camp":
			var temp = camp.instantiate()
			temp.position = Vector2i(playableArea.x / 2, playableArea.y - 25)
			interactables.append(temp)
			add_child(temp)

func spawnStagecoaches(coaches: Array): #array of stage coach objects
	pass
	var angleIncrement = (PI) / coaches.size()
	var distanceFromCamp = 100
	var campPosition = Vector2(float(playableArea.x)/2, playableArea.y)
	
	for i in coaches.size():
		pass #spawn stagecoaches, apply data to stage coach
		var temp = stageCoach.instantiate()
		var displacementVector = (Vector2.from_angle((angleIncrement * i) - (PI/2) - angleIncrement) * distanceFromCamp)
		temp.position = campPosition + displacementVector
		stageCoaches.append(temp)
		temp.setStagecoachData(coaches[i].getStagecoachData())
		add_child(temp)

func deleteInteractable(node: Node2D):
	interactables.erase(node)
	node.queue_free()

func adjustPlayableArea(newSize: Vector2i): #call this function when game window is resized
	playableArea = newSize


func _on_round_timer_timeout() -> void:
	pass # Replace with function body.
	inGameMain.loadDay()
