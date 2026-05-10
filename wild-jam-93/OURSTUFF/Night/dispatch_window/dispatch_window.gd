class_name DispatchWindow extends Control

signal dispatched ## start moving stagecoach once this is emitted

var selected_hunter: Hunter

@onready var _bounty_prize: Label = $BountyPanel/Prize
@onready var _bounty_icon: TextureRect = $BountyPanel/Icon
@onready var _stagecoach_power: Label = $StagecoachPanel/VBoxContainer/Power
@onready var _stagecoach_stamina: Label = $StagecoachPanel/VBoxContainer/Stamina
@onready var hunter_grid: GridContainer = $HunterGrid

func show_dispatch_panel(stagecoach: StageCoach, bounty: Bounty) -> void:
	_stagecoach_power.text = "Power: %s" % stagecoach.hunters.size()
	_stagecoach_stamina.text = "Stamina: %s" % stagecoach.stamina
	_bounty_prize.text = "$ %s" % bounty.reward
	_bounty_icon.texture = load("res://icon.png") # TODO each boutny different image?
	
	for i in stagecoach.hunters.size():
		assert(stagecoach.hunters[i] != null)
		
		(hunter_grid.get_child(i) as HunterSlot).hunter = stagecoach.hunters[i]
	
	show()


func _on_dispatch_button_pressed() -> void:
	hide()
	dispatched.emit()


## needs to get a signal which notifies that user has selected a bounty hunter
func _on_hunter_selected() -> void:
	for hunter_slot: HunterSlot in hunter_grid.get_children():
		hunter_slot.add_border_highlight()


func _on_hunter_slot_selected(hunter_slot: HunterSlot) -> void:
	assert(selected_hunter != null)
	
	hunter_slot.hunter = selected_hunter
