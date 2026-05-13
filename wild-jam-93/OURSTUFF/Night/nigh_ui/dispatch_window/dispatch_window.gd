class_name DispatchWindow extends Control

signal dispatched(connectedStagecoach: StageCoach) ## start moving stagecoach once this is emitted
signal hunter_assigned(hunter: Hunter)

var selected_hunter: Hunter:
	set(value):
		selected_hunter = value
		if value == null:
			for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
				stagecoach_slot.remove_border_highlight()
var stagecoach: StageCoach
var interactable: Node2D 

@onready var _interactables_description: Label = $InteractablesPanel/Description # changed form prize
@onready var _interactables_icon: TextureRect = $InteractablesPanel/Icon
@onready var _interactables_title: Label = $InteractablesPanel/Title
@onready var _interactables_stamina: Label = $InteractablesPanel/VBoxContainer/RequiredStamina
@onready var _stagecoach_power: Label = $StagecoachPanel/VBoxContainer/Power
@onready var _stagecoach_stamina: Label = $StagecoachPanel/VBoxContainer/Stamina
@onready var hunter_grid: GridContainer = $HunterGrid

func show_dispatch_panel(new_stagecoach: StageCoach, new_interactable: Node2D) -> void:
	for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
		stagecoach_slot.hunter = null
	
	stagecoach = new_stagecoach
	interactable = new_interactable
	
	var temp = (stagecoach.global_position - interactable.global_position).length() / stagecoach.speed
	
	var interactableData = interactable.getInteractableData()
	_stagecoach_power.text = "Power: %s" % stagecoach.hunters.size()
	_stagecoach_stamina.text = "Stamina: %.1f" % stagecoach.stamina
	_interactables_description.text = "%s" % interactableData["dispatchDescription"]
	_interactables_icon.texture = load(interactableData["dispatchIcon"]) # TODO each boutny different image?
	_interactables_title.text = interactableData["dispatchTitle"]
	if interactable is Camp:
		_interactables_stamina.text = "Req. Stamina: %.1f" % 0
	else:
		_interactables_stamina.text = "Req. Stamina: %.1f" % temp
	
	print(stagecoach.isInteracting)
	for i in stagecoach.hunters.size():
		assert(stagecoach.hunters[i] != null)
		
		(hunter_grid.get_child(i) as StagecoachSlot).hunter = stagecoach.hunters[i]
	
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


func _on_hunter_slot_hunter_removed(hunter: Hunter) -> void:
	print("hunter removed")
	hunter.state = Hunter.State.AVAILABLE
	stagecoach.hunters.erase(hunter)


func _on_cancel_button_pressed() -> void:
	hide()
