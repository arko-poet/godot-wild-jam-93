class_name HunterPanel extends Panel

signal hunter_selected(selected_hunter: Hunter)

const portrait = preload("res://OURSTUFF/Night/Animation/UI_ART/portrait_test.tscn")

const STATE_COLORS: Dictionary[Hunter.State, Color] = {
	Hunter.State.AVAILABLE: Color("#34D399"),
	Hunter.State.BUSY: Color("#FBBF24"),
	Hunter.State.UNAVAILABLE: Color("#F87171")
}
const VOICE_LINES := [
	preload("res://OURSTUFF/sound/voice_lines/arko/Nagrywanie (11).ogg"),
	preload("res://OURSTUFF/sound/voice_lines/arko/Nagrywanie (12).ogg"),
	preload("res://OURSTUFF/sound/voice_lines/arko/Nagrywanie (13).ogg"),
	preload("res://OURSTUFF/sound/voice_lines/arko/Nagrywanie (14).ogg"),
	preload("res://OURSTUFF/sound/voice_lines/arko/Nagrywanie (15).ogg")
]
const BORDER_COLOR := Color.WHITE
const BORDER_WIDTH := 3
const BORDER_OVERRIDE_NAME := &"border"

var hunter: Hunter:
	set(value):
		assert(hunter == null) # hunter is only meant to be set once
		hunter = value
		icon.texture = load(hunter.face_texture_path)
		var temp = portrait.instantiate()
		add_child(temp)
		temp._init_seeded_portrait(hunter.hunterFaceSeed)
		
		hunter.state_changed.connect(_hunter_state_changed)
		get_theme_stylebox(&"panel").bg_color = STATE_COLORS[hunter.state]

@onready var icon: TextureRect = $Icon
@onready var voice_line_player: AudioStreamPlayer2D = $VoiceLinePlayer


func remove_border() -> void:
	get_theme_stylebox(&"panel").set_border_width_all(0)
	get_theme_stylebox(&"panel").shadow_size = 0


func _add_border() -> void:
	var style := get_theme_stylebox(&"panel").duplicate(true)

	style.border_color = BORDER_COLOR
	style.set_border_width_all(BORDER_WIDTH)

	add_theme_stylebox_override(&"panel", style)
	get_theme_stylebox(&"panel").shadow_size = 8
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if hunter.state == Hunter.State.AVAILABLE:
			_play_voice_line()
			hunter_selected.emit(hunter)
			_add_border()


func _play_voice_line() -> void:
	if VOICE_LINES.is_empty():
		return

	var line = VOICE_LINES.pick_random()

	voice_line_player.stream = line
	voice_line_player.play()


func _hunter_state_changed() -> void:
	print("hunter state changed")
	get_theme_stylebox(&"panel").bg_color = STATE_COLORS[hunter.state]
