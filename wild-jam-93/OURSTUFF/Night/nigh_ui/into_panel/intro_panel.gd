extends Control

signal intro_finished

const INTRO: Array[String] = [
	"Welcome Dispatcher.",
	"Every night, stars fall across the desert.",
	"Stars are a source of stardust, a valuable fuel.",
	"The mayor pays bounties for recovered stars.",
	"Many try to collect them, but the desert is full of dangers - and competition.",
	"Your goal is to manage a gang of hunters to collect the stars and maximise profit.",
	"Select a stagecoach, assign hunters and pick a star to hunt.",
	"Be quick or other gangs will claim them before you.",
	"Good Luck."
]

var index := 0

@onready var label: Label = $GameIntro/Label


func _ready() -> void:
	label.text = INTRO[index]


func _on_gui_input(event: InputEvent) -> void:
	# advance intro on left click
	if event is InputEventMouseButton and event.pressed:
		index += 1
		if index == INTRO.size():
			hide()
			intro_finished.emit()
		else:
			label.text = INTRO[index]
