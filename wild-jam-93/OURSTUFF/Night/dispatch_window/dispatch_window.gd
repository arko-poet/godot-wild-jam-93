class_name DispatchWindow extends Control

signal dispatched ## start moving stagecoach once this is emitted

var selected_hunter ## TODO decide on type

@onready var _bounty_title: Label = $BountyPanel/Title
@onready var _bounty_prize: Label = $BountyPanel/Prize
@onready var _bounty_icon: TextureRect = $BountyPanel/Icon
@onready var _stagecoach_power: Label = $StagecoachPanel/VBoxContainer/Power
@onready var _stagecoach_stamina: Label = $StagecoachPanel/VBoxContainer/Stamina
@onready var hunter_grid: GridContainer = $HunterGrid

## TODO We need to decide how we are going to structure this
## Ideally we should use objects
##
## stagecoach: needs to contain data about selected stagecoach
## 			   which bounty hunters are in it etc.
## bounty: this will be data about bounty depending on the selected star 
func show_dispatch_panel(stagecoach: StageCoach, bounty: Bounty) -> void:
	# TODO setup stagecoach grid with stagecoach data/object
	
	# TODO setup Bounty panel with bounty data/object
	
	show()


func _on_dispatch_button_pressed() -> void:
	hide()
	dispatched.emit()


## needs to get a signal which notifies that user has selected a bounty hunter
func _on_hunter_selected() -> void:
	for hunter_slot: HunterSlot in hunter_grid:
		hunter_slot.add_border_highlight()


func _on_hunter_slot_selected(hunter_slot: HunterSlot) -> void:
	assert(selected_hunter != null)
	
	hunter_slot = selected_hunter
