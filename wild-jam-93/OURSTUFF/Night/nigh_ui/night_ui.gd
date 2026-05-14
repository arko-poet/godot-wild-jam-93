class_name NighUI extends Control

signal hunter_selected(hunter: Hunter)

const HunterPanelScene: PackedScene = preload("res://OURSTUFF/Night/nigh_ui/hunter_panel/hunter_panel.tscn")

var hunters: Dictionary[Hunter, HunterPanel]
var selected_hunter: Hunter:
	set(value):
		if value != null and value.state == Hunter.State.AVAILABLE:
			selected_hunter = value
			hunter_selected.emit(selected_hunter)

@onready var hunter_grid: GridContainer = $VBoxContainer/HunterGrid
@onready var time_left_label: Label = $TimeLeftLabel
@onready var money_label: Label = $MoneyLabel
@onready var pause_button: Button = $HBoxContainer/PauseButton
@onready var speed_1_button: Button = $HBoxContainer/Speed1Button
@onready var speed_2_button: Button = $HBoxContainer/Speed2Button
@onready var speed_4_button: Button = $HBoxContainer/Speed4Button


#func _ready() -> void:
	## jsut a TEST to be removed
	#for i in 10:
		#var hunter = Hunter.new("res://icon.png")
		#add_hunter(hunter)
##
#
#var test: float = 0
#func _process(delta: float) -> void:
	#test += delta
	#print(test)


func add_hunter(hunter: Hunter) -> void:
	var hunter_panel: HunterPanel = HunterPanelScene.instantiate()
	hunter_grid.add_child(hunter_panel)
	hunter_panel.hunter = hunter
	hunters[hunter] = hunter_panel
	hunter_panel.hunter_selected.connect(_on_hunter_selected)


func update_time_left(seconds_left: int) -> void:
	@warning_ignore("integer_division") 
	var minutes := seconds_left / 60 
	var seconds := seconds_left % 60
	time_left_label.text = "%d:%02d" % [minutes, seconds]
	
	
func update_money(money: int) -> void:
	money_label.text = "$%s" % money


func _on_pause_button_pressed() -> void:
	if get_tree().paused == false:
		pause_button.text = "▶"
	else:
		pause_button.text = "II"
	get_tree().paused = !get_tree().paused


func _on_speed_1_button_pressed() -> void:
	Engine.time_scale = 1.0
	speed_1_button.disabled = true
	speed_2_button.disabled = false
	speed_4_button.disabled = false


func _on_speed_2_button_pressed() -> void:
	Engine.time_scale = 2.0
	speed_1_button.disabled = false
	speed_2_button.disabled = true
	speed_4_button.disabled = false


func _on_speed_4_button_pressed() -> void:
	Engine.time_scale = 4.0
	speed_1_button.disabled = false
	speed_2_button.disabled = false
	speed_4_button.disabled = true


func _on_hunter_selected(hunter: Hunter) -> void:
	selected_hunter = hunter
	for h in hunters:
		if h != hunter:
			hunters[h].remove_border()


func _on_dispatch_window_hunter_assigned(hunter: Hunter) -> void:
	hunters[hunter].remove_border()
	selected_hunter = null
