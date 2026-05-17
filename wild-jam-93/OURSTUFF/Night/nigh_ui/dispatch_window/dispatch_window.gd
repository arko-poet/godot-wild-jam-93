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
var stamina_needed

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
@onready var whip_sound: AudioStreamPlayer2D = $WhipSound
@onready var loot_text: Label = $StagecoachPanel/VBoxContainer/Loot
@onready var interactable_timeLeft: Label = $InteractablesPanel/timeleft

var inGameNightMain

func _ready() -> void:
	inGameNightMain = find_parent("InGameNightMain")

func _physics_process(delta: float) -> void:
	if (interactable != null) && (interactable is not Camp):
		interactable_timeLeft.visible = true
		interactable_timeLeft.text = "0:%.1f" % interactable.decayTimer.time_left 
		#need formating thing that adds zero in front if less than 10
	else:
		interactable_timeLeft.visible = false

func show_dispatch_panel(new_stagecoach: StageCoach, new_interactable: Node2D) -> void:
	stagecoach = new_stagecoach
	interactable = new_interactable
	if interactable is not Camp:
		interactable.bounty_expired.connect(_on_bounty_expired)
	# clean slots from previously selected stagecoach
	for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
		stagecoach_slot.hunter = null
	
	#loot text
	var loot = 0
	for i in stagecoach.bounties:
		loot += i.reward
	loot_text.text = "Return to town to redeem $%s" % loot
	
	# bounty properties
	var reward: String
	stamina_needed = (stagecoach.global_position - interactable.global_position).length() / stagecoach.speed
	if interactable is Camp:
		_interactables_stamina.hide()
		_fail_chance.hide()
		stamina_needed = 0.0
		reward = "+ Resupply\n+ Heal"
	elif interactable is PowerUp:
		_fail_chance.hide()
		_interactables_stamina.show()
		reward = interactable.powerUpDescription
	else:
		interactable.updateFailChance(stagecoach.hunters)
		_interactables_stamina.show()
		_fail_chance.show()
		reward = "$%s" % interactable.bounty.reward

	# bounty/interactable display
	var interactableData = interactable.getInteractableData()
	_interactables_reward.text = reward
	#_interactables_difficulty.text = "Difficulty: %s" % difficulty
	_interactables_icon.texture = load(interactableData["dispatchIcon"])
	_interactables_title.text = interactableData["dispatchTitle"]
	_interactables_stamina.text = "%.1f miles" % stamina_needed
	
	# stagecoach properties
	_stagecoach_stamina.text = "Stamina: %.1f/%.1f" % [stagecoach.stamina, Camp.MAX_STAMINA]

	
	# stagecoach slot filling
	for i in stagecoach.hunters.size():
		assert(stagecoach.hunters[i] != null)
		(hunter_grid.get_child(i) as StagecoachSlot).hunter = stagecoach.hunters[i]
		
	# inform player if sufficient stamina and at least one hunter
	dispatch_button.disabled = (stagecoach.stamina < stamina_needed) || (stagecoach.hunters.size() <= 0)
	if (stagecoach.stamina < stamina_needed):
		dispatch_button.tooltip_text = "INSUFFICIENT STAMINA\nRESUPPLY IN TOWN"
	elif (stagecoach.hunters.size() <= 0):
		dispatch_button.tooltip_text = "NOT ENOUGH HUNTERS"
	else:
		dispatch_button.tooltip_text = ""
	
	_update_hunter_power()
	
	show()


func _on_dispatch_button_pressed() -> void:
	var tweens = get_tree().create_tween()
	tweens.tween_property($stagecoach, "position", Vector2(800, 37), 0.5)
	tweens.parallel().tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
	tweens.parallel().tween_property($HunterGrid, "position", Vector2(928, 64), 0.5)
	await tweens.finished
	$stagecoach.position = Vector2(68, 37)
	$HunterGrid.position = Vector2(128, 64)
	modulate = Color.WHITE
	
	if interactable is not Camp:
		interactable.bounty_expired.disconnect(_on_bounty_expired)
	hide()
	dispatched.emit(stagecoach)
	whip_sound.play()


func _on_hunter_selected(hunter: Hunter) -> void:
	selected_hunter = hunter
	for stagecoach_slot: StagecoachSlot in hunter_grid.get_children():
		if stagecoach_slot.hunter == null and stagecoach != null and stagecoach.isAtCamp:
			stagecoach_slot.add_border_highlight()


## add hunter to a stagecoach
func _on_hunter_slot_selected(stagecoach_slot: StagecoachSlot) -> void:
	if selected_hunter != null and stagecoach.isAtCamp:
		print(selected_hunter.at_camp)
		stagecoach_slot.hunter = selected_hunter
		stagecoach.hunters.append(selected_hunter)
		hunter_assigned.emit(selected_hunter)
		selected_hunter = null
		_update_hunter_power()


func _on_hunter_slot_hunter_removed(hunter: Hunter) -> void:
	hunter.state = Hunter.State.AVAILABLE
	stagecoach.hunters.erase(hunter)
	_update_hunter_power()


func _on_cancel_button_pressed() -> void:
	if (interactable != null) && (interactable is not Camp):
		interactable.bounty_expired.disconnect(_on_bounty_expired)
	hide()
	cancel.emit()


func _update_hunter_power() -> void:
	# hunter power
	var power := 0
	for hunter in stagecoach.hunters:
		if hunter.state != Hunter.State.UNAVAILABLE:
			power += hunter.power
	_stagecoach_power.text = "Power: %s" % power
	
	# bounty fail chance
	if (interactable is not Camp) && (interactable is not PowerUp):
		interactable.updateFailChance(stagecoach.hunters)
		_fail_chance.text = "Fail Chance: %s%%" % int(interactable.failChance * 100.0)
	
	dispatch_button.disabled = (stagecoach.stamina < stamina_needed) || (stagecoach.hunters.size() <= 0) || (power == 0 and interactable is not Camp)
	if (stagecoach.stamina < stamina_needed):
		dispatch_button.tooltip_text = "INSUFFICIENT STAMINA\nRESUPPLY IN TOWN"
	elif (stagecoach.hunters.size() <= 0):
		dispatch_button.tooltip_text = "NOT ENOUGH HUNTERS"
	elif power == 0:
		dispatch_button.tooltip_text = "HEAL IN TOWN"
	else:
		dispatch_button.tooltip_text = ""


func _on_bounty_expired(_p_position) -> void:
	dispatch_button.disabled = true
	dispatch_button.tooltip_text = "DESTINATION EXPIRED"
