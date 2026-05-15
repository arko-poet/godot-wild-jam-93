extends Control

signal intro_finished

const INTRO: Array[String] = [
	"Welcome to the [world name]!",
	"Every night, valuable stars appear in the desert.",
	"Many try to collect them, but the desert is full of dangers — and competition.",
	"The town’s mayor pays bounties for recovered stars.",
	"You've gathered a bunch of bounty hunters and stagecoaches",
	"Dispatch them into the desert, recover the stars, and maximize your profit.",
	"Good Luck!"
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
