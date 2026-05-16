class_name NighUI extends Control

signal hunter_selected(hunter: Hunter)
signal play_again

const HunterPanelScene: PackedScene = preload("res://OURSTUFF/Night/nigh_ui/hunter_panel/hunter_panel.tscn")

var inGameNightMain 
var hunters: Dictionary[Hunter, HunterPanel]
var selected_hunter: Hunter:
	set(value):
		if value != null and value.state == Hunter.State.AVAILABLE:
			selected_hunter = value
			hunter_selected.emit(selected_hunter)

@onready var hunter_grid: GridContainer = $HunterBox/HunterGrid
@onready var time_left_label: Label = $TimeLeftLabel
@onready var money_label: Label = $MoneyLabel
@onready var pause_button: Button = $HBoxContainer/PauseButton
@onready var speed_1_button: Button = $HBoxContainer/Speed1Button
@onready var speed_2_button: Button = $HBoxContainer/Speed2Button
@onready var speed_4_button: Button = $HBoxContainer/Speed4Button
@onready var helpbutton: Button = $HelpButton
@onready var help_panel: Panel = $HelpPanel
@onready var close_help_panel_button: Button = $HelpPanel/MarginContainer/CloseButton
@onready var score_panel: PanelContainer = $ScorePanel
@onready var score_label: Label = $ScorePanel/VBoxContainer/ScoreLabel
@onready var hunter_box: VBoxContainer = $HunterBox


#
#var test: float = 0
#func _process(delta: float) -> void:
	#test += delta
	#print(test)

func _ready() -> void:
	inGameNightMain = find_parent("InGameNightMain")

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


func show_score_panel(money: int) -> void:
	score_label.text = "You've earned  %s$ this night." % money
	inGameNightMain.find_child("DispatchWindow").hide()
	score_panel.show()



func _on_pause_button_pressed() -> void:
	if get_tree().paused == false:
		pause_button.text = ">"
	else:
		pause_button.text = "II"
	if !help_panel.visible:
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


func _on_helpbutton_pressed() -> void:
	help_panel.show()
	get_tree().paused = true


func _on_close_button_pressed() -> void:
	help_panel.hide()
	get_tree().paused = false


func _on_play_again_button_pressed() -> void:
	play_again.emit()


func _on_dispatch_window_cancel() -> void:
	hunter_box.hide()
