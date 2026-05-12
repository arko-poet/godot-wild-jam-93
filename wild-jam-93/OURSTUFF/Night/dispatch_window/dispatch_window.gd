class_name DispatchWindow extends Control

signal dispatched(connectedStagecoach: StageCoach) ## start moving stagecoach once this is emitted
signal hunter_assigned(hunter: Hunter)

var selected_hunter: Hunter:
	set(value):
		selected_hunter = value
		if value == null:
			for hunter_slot: HunterSlot in hunter_grid.get_children():
				hunter_slot.remove_border_highlight()
var stagecoach: StageCoach
var interactable: Node2D 

@onready var _interactables_description: Label = $InteractablesPanel/Description # changed form prize
@onready var _interactables_icon: TextureRect = $InteractablesPanel/Icon
@onready var _stagecoach_power: Label = $StagecoachPanel/VBoxContainer/Power
@onready var _stagecoach_stamina: Label = $StagecoachPanel/VBoxContainer/Stamina
@onready var hunter_grid: GridContainer = $HunterGrid

func show_dispatch_panel(new_stagecoach: StageCoach, new_interactable: Node2D) -> void:
	for hunter_slot: HunterSlot in hunter_grid.get_children():
		hunter_slot.hunter = null
	
	stagecoach = new_stagecoach
	interactable = new_interactable
	
	var interactableData = interactable.getInteractableData()
	_stagecoach_power.text = "Power: %s" % stagecoach.hunters.size()
	_stagecoach_stamina.text = "Stamina: %s" % stagecoach.stamina
	_interactables_description.text = "%s" % interactableData["dispatchDescription"]
	_interactables_icon.texture = load(interactableData["dispatchIcon"]) # TODO each boutny different image?
	
	print(stagecoach)
	for i in stagecoach.hunters.size():
		assert(stagecoach.hunters[i] != null)
		
		(hunter_grid.get_child(i) as HunterSlot).hunter = stagecoach.hunters[i]
	
	show()


func _on_dispatch_button_pressed() -> void:
	hide()
	dispatched.emit(stagecoach)


## needs to get a signal which notifies that user has selected a bounty hunter
func _on_hunter_selected(hunter: Hunter) -> void:
	selected_hunter = hunter
	for hunter_slot: HunterSlot in hunter_grid.get_children():
		if hunter_slot.hunter == null:
			hunter_slot.add_border_highlight()


func _on_hunter_slot_selected(hunter_slot: HunterSlot) -> void:
	if selected_hunter != null:
		hunter_slot.hunter = selected_hunter
		stagecoach.hunters.append(selected_hunter)
		hunter_assigned.emit(selected_hunter)
		selected_hunter = null


func _on_hunter_slot_hunter_removed(hunter: Hunter) -> void:
	print("hunter removed")
	hunter.state = Hunter.State.AVAILABLE
	stagecoach.hunters.erase(hunter)
