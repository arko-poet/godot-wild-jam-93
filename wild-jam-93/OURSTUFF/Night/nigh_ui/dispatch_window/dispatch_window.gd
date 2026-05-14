class_name DispatchWindow extends Control

signal dispatched(connectedStagecoach: StageCoach) ## start moving stagecoach once this is emitted
signal cancel
signal hunter_assigned(hunter: Hunter)

var selected_hunter: Hunter:
	set(value):
		selected_hunter = value
		if value == null:
			for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
				stagecoach_slot.remove_border_highlight()
var stagecoach: StageCoach
var interactable: Node2D 

@onready var _interactables_reward: Label = $InteractablesPanel/Description # changed form prize
@onready var _interactables_icon: TextureRect = $InteractablesPanel/Icon
@onready var _interactables_title: Label = $InteractablesPanel/Title
@onready var _interactables_stamina: Label = $InteractablesPanel/VBoxContainer/RequiredStamina
@onready var _interactables_difficulty: Label = $InteractablesPanel/VBoxContainer/Difficulty
@onready var _stagecoach_power: Label = $StagecoachPanel/VBoxContainer/Power
@onready var _stagecoach_stamina: Label = $StagecoachPanel/VBoxContainer/Stamina
@onready var _fail_chance: Label = $InteractablesPanel/VBoxContainer/FailChance
@onready var hunter_grid: GridContainer = $HunterGrid
@onready var dispatch_button: Button = $HBoxContainer/DispatchButton

var inGameNightMain

func _ready() -> void:
	inGameNightMain = find_parent("InGameNightMain")

func show_dispatch_panel(new_stagecoach: StageCoach, new_interactable: Node2D) -> void:
	for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
		stagecoach_slot.hunter = null
	
	stagecoach = new_stagecoach
	interactable = new_interactable
	
	var reward
	var failValue
	var difficulty
	var stamina_needed = (stagecoach.global_position - interactable.global_position).length() / stagecoach.speed
	if interactable is Camp:
		stamina_needed = 0.0
		failValue = 0
		difficulty = 0
		reward = 0
	else:
		interactable.updateFailChance(stagecoach.hunters)
		failValue = int(interactable.failChance * 100)
		difficulty = interactable.bounty.difficulty
		reward = interactable.bounty.reward

	# stagecoach properties
	_stagecoach_stamina.text = "Stamina: %.1f/%.1f" % [stagecoach.stamina, Camp.MAX_STAMINA]
	_update_hunter_power()

	
	var interactableData = interactable.getInteractableData()
	_interactables_reward.text = "Reward: $%s" % reward
	_interactables_difficulty.text = "Difficulty: %s" % difficulty
	_interactables_icon.texture = load(interactableData["dispatchIcon"])
	_interactables_title.text = interactableData["dispatchTitle"]
	_interactables_stamina.text = "Req. Stamina: %.1f" % stamina_needed
	_fail_chance.text = "Fail Chance: %%%s" % failValue
	
	print(stagecoach.isInteracting)
	for i in stagecoach.hunters.size():
		assert(stagecoach.hunters[i] != null)
		
		(hunter_grid.get_child(i) as StagecoachSlot).hunter = stagecoach.hunters[i]
		
	# check if sufficient stamina
	dispatch_button.disabled = stagecoach.stamina < stamina_needed
	if dispatch_button.disabled:
		dispatch_button.tooltip_text = "INSUFFICIENT STAMINA!"
	else:
		dispatch_button.tooltip_text = ""
	
	show()


func _on_dispatch_button_pressed() -> void:
	hide()
	dispatched.emit(stagecoach)


## needs to get a signal which notifies that user has selected a bounty hunter
func _on_hunter_selected(hunter: Hunter) -> void:
	selected_hunter = hunter
	for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
		if stagecoach_slot.hunter == null:
			stagecoach_slot.add_border_highlight()


func _on_hunter_slot_selected(stagecoach_slot: StagecoachSlot) -> void:
	if selected_hunter != null:
		stagecoach_slot.hunter = selected_hunter
		stagecoach.hunters.append(selected_hunter)
		hunter_assigned.emit(selected_hunter)
		selected_hunter = null
		_update_hunter_power()


func _on_hunter_slot_hunter_removed(hunter: Hunter) -> void:
	print("hunter removed")
	hunter.state = Hunter.State.AVAILABLE
	stagecoach.hunters.erase(hunter)
	_update_hunter_power()


func _on_cancel_button_pressed() -> void:
	hide()
	cancel.emit()


func _update_hunter_power() -> void:
	var power := 0
	for hunter in stagecoach.hunters:
		power += hunter.power
	_stagecoach_power.text = "Power: %s" % power
