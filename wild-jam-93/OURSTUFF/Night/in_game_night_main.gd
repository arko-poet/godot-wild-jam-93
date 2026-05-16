class_name Night extends Node2D
#this script is in charge of everything involved during the night section of the game
 
const stageCoach = preload("res://OURSTUFF/Night/dev_stagecoach.tscn") #stage coach scene
const star = preload("res://OURSTUFF/Night/stagecoachInteractables/star.tscn") #star scene
const powerUp = preload("res://OURSTUFF/Night/power_ups/default_power_up.tscn")
const starAnimation = preload("res://OURSTUFF/Night/Animation/star_animation.tscn")
const camp = preload("res://OURSTUFF/Night/stagecoachInteractables/camp.tscn")
#const dispatchWindow = preload("res://OURSTUFF/Night/dispatch_window/dispatch_window.tscn")
const devHunterIcon = "res://OURSTUFF/resources/devBountyHunter.png"
const FloatingText: PackedScene = preload("res://OURSTUFF/Night/nigh_ui/floating_text/floating_text.tscn")
const NIGHT_DURATION := 300.0

@export var interactableSelectionRange := 50.0
@export var stagecoachSelectionRange := 75.0
@export var overlapRange := 75
@export var stagecoachSelectScale := 1.2
@export var interactableSelectScale := 1.5

var starSpawnHighRoll := 7.0
var starSpawnLowRoll := 3.0

var playableArea := Vector2i(1280, 720)

var stageCoaches = [] #array of all stagecoaches
var interactables = [] #array of stagecoach interactables
var selectedStageCoach:
	set(value):
		if value == null and selectedStageCoach != null:
			selectedStageCoach.selected = false
		selectedStageCoach = value
		if selectedStageCoach != null:
			selectedStageCoach.selected = true
var selectedInteractable:
	set(value):
		if value is not Camp:
			if value == null and selectedInteractable != null:
				selectedInteractable.selected = false
			selectedInteractable = value
			if selectedInteractable != null:
				selectedInteractable.selected = true
		else:
			selectedInteractable = value

var inGameMain

@onready var dispatchUiLayer = $dispatchUiLayer
@onready var night_ui: NighUI = $dispatchUiLayer/NightUI
@onready var dispatch_window: DispatchWindow = $dispatchUiLayer/DispatchWindow
@onready var roundTimer = $roundTimer
@onready var starSpawnTimer = $starSpawnTimer
@onready var nightModulate = $Map/NightModulate

func _ready() -> void:
	inGameMain = find_parent("InGameMain")
	
	night_ui.update_money(inGameMain.money)
	
	spawnInteractable("powerUp", Vector2(playableArea.x/2, playableArea.y/2))


func _process(delta: float) -> void:
	
	#update ui time
	night_ui.update_time_left(int(roundTimer.time_left + 1.0))
	var percentRemainingNight = 1 - (roundTimer.time_left / roundTimer.wait_time)
	nightModulate.updateColor(percentRemainingNight)
	
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
		if selectedInteractable != null:
			selectedInteractable.sprite.scale /= interactableSelectScale
			selectedInteractable = null
		if selectedStageCoach != null:
			selectedStageCoach.setSpriteScale(1.0)
			selectedStageCoach.material.light_mode = 0
			selectedStageCoach = null
		
		dispatch_window.hide()
		night_ui.hunter_box.hide()
		# can also be deselected via ui
	


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
		if (distance <= stagecoachSelectionRange) && (stageCoaches[i].isInteracting == false):
			selectedStageCoach = stageCoaches[i]
			selectedStageCoach.setSpriteScale(1.2)
			selectedStageCoach.material.light_mode = 1
			#highlight coach or something
			selectedStageCoach.selected = true
			if selectedInteractable != null:
				dispatch_window.show_dispatch_panel(selectedStageCoach, selectedInteractable)
				night_ui.hunter_box.show()
			break

func selectInteractable():
	pass #attempt to select anyinteractable
	for i in interactables.size():
		if interactables[i] != null: #jank. check in any null values in array and delete
			var distance = (get_global_mouse_position() - interactables[i].global_position).length()
			if distance <= interactableSelectionRange:
				var temp = false
				for n in stageCoaches:
					if (n.interactingNode == interactables[i]) && (interactables[i] is not Camp): #cannont select destination of another stagecoach (except camp)
						temp = true
						break
				if !temp:
					selectedInteractable = interactables[i]
					selectedInteractable.sprite.scale *= interactableSelectScale
					#call a function to spawn ui element here
					if selectedStageCoach != null:
						
						dispatch_window.show_dispatch_panel(selectedStageCoach, selectedInteractable)
						night_ui.hunter_box.show()
				break
		else:
			interactables.remove_at(i)



func dispatchStagecoach(stagecoach: StageCoach): # called by the ui when player clicks dispatch
	if (selectedInteractable != null) && (selectedStageCoach != null):
		if selectedInteractable.canInteract(selectedStageCoach) == true:
			selectedInteractable.stopDecayTimer()
			selectedStageCoach.dispatch(selectedInteractable)
			selectedInteractable.sprite.scale /= interactableSelectScale
			selectedStageCoach.setSpriteScale(1.0)
			selectedStageCoach.material.light_mode = 0
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
		temp = Vector2(randf_range(90,playableArea.x), randf_range(0,playableArea.y - 50))
		for i in allClickables:
			if (temp - i.global_position).length() < overlapRange:
				isOverlaping = true
				break
	#star animation
	var animation = starAnimation.instantiate()
	animation.global_position = Vector2(randi_range(0, playableArea.x), -10)
	animation.target = temp
	animation.impact_ground.connect(spawnInteractable.bind("star", temp))
	add_child(animation)
	starSpawnTimer.start(randf_range(3, 7))


func spawnInteractable(type: String, location: Vector2): #controls spawning of stars, objects, locations etc
	pass
	match type:
		"star":
			var temp =  star.instantiate()
			temp.bounty_expired.connect(_on_bounty_expired)
			temp.global_position = location
			interactables.append(temp)
			temp.bounty_completed.connect(_on_bounty_completed)
			
			for i in get_children():
				if i is AnimationStar:
					i.reparent(temp)
					
			add_child(temp)
		"camp":
			var temp = camp.instantiate()
			temp.position = Vector2i(playableArea.x / 2, playableArea.y - 25)
			interactables.append(temp)
			add_child(temp)
		"powerUp":
			var temp = powerUp.instantiate()
			interactables.append(temp)
			temp.global_position = location
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
		temp.ui_layer = dispatchUiLayer
		add_child(temp)
		

func deleteInteractable(node: Node2D):
	interactables.erase(node)
	node.queue_free()
	if node is Star:
		node.star_time_bar.queue_free()
		node.bounty_progress_label.queue_free()


func adjustPlayableArea(newSize: Vector2i): #call this function when game window is resized
	playableArea = newSize


func _on_round_timer_timeout() -> void:
	night_ui.show_score_panel(inGameMain.money)
	get_tree().paused = true


func _on_dispatch_window_cancel() -> void:
	pass # Replace with function body.
	if selectedInteractable != null:
		selectedInteractable.sprite.scale /= interactableSelectScale
		selectedInteractable = null
	if selectedStageCoach != null:
		selectedStageCoach.setSpriteScale(1.0)
		selectedStageCoach = null


func _on_bounty_completed(success: bool, p_position: Vector2) -> void:
	# Floating Text
	var floating_text := FloatingText.instantiate()
	var text
	if success:
		text = "SUCCESS"
		floating_text.modulate = Color.GREEN
	else:
		text = "FAILURE"
		floating_text.modulate = Color.RED
	dispatchUiLayer.add_child(floating_text)
	floating_text.position = p_position
	floating_text.show_text(text)


func _on_bounty_expired(p_position) -> void:
	var floating_text := FloatingText.instantiate()
	var text := "EXPIRED"
	floating_text.modulate = Color.YELLOW
	dispatchUiLayer.add_child(floating_text)
	floating_text.position = p_position
	floating_text.show_text(text)


func _on_night_ui_intro_finished() -> void:
	# start night
	starSpawnTimer.start(1)
	roundTimer.start(NIGHT_DURATION)
	for i in stageCoaches:
		i.lightTimer.start(randf_range(20, 30))
	spawnInteractable("camp", Vector2(0,0))
	night_ui.show()


func _on_night_ui_play_again() -> void:
	get_tree().paused = false
	# this just restarts the scene, not ideal but has to do for now
	SceneLoader.reload_current_scene()
	
	#night_ui.score_panel.hide()
	#inGameMain.loadDay()
