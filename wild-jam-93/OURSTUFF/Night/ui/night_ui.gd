class_name NighUI extends Control

@onready var hunter_grid: GridContainer = $VBoxContainer/HunterGrid
@onready var time_left_label: Label = $TimeLeftLabel
@onready var money_label: Label = $MoneyLabel
@onready var settings_button: Button = $SettingsButton
@onready var pause_button: Button = $HBoxContainer/PauseButton
@onready var speed_1_button: Button = $HBoxContainer/Speed1Button
@onready var speed_2_button: Button = $HBoxContainer/Speed2Button
@onready var speed_4_button: Button = $HBoxContainer/Speed4Button


#func _ready() -> void:
	#update_time_left(1284)
#
#
#var test: float = 0
#func _process(delta: float) -> void:
	#test += delta
	#print(test)


func add_hunter(hunter: Hunter) -> void:
	pass


func remove_hunter(hunter: Hunter) -> void:
	pass


## if something changed with hunter that needs to be dispalyed
func update_hunter(hunter: Hunter) -> void:
	pass


func update_time_left(seconds_left: int) -> void:
	var minutes := seconds_left / 60
	var seconds := seconds_left % 60
	time_left_label.text = "%d:%02d" % [minutes, seconds]
	
	
func set_money(money: int) -> void:
	money_label.text = "4 %s" % money


func _on_pause_button_pressed() -> void:
	if get_tree().paused == false:
		pause_button.text = "▶"
	else:
		pause_button.text = "II"
	get_tree().paused = !get_tree().paused


func _on_speed_1_button_pressed() -> void:
	Engine.time_scale = 1.0


func _on_speed_2_button_pressed() -> void:
	Engine.time_scale = 2.0


func _on_speed_4_button_pressed() -> void:
	Engine.time_scale = 4.0


func _on_settings_button_pressed() -> void:
	# TODO figure out how to use template to open settings
	pass # Replace with function body.
