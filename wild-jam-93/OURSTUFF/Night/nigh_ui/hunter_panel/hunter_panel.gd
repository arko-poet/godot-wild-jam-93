class_name HunterPanel extends Panel

signal hunter_selected(selected_hunter: Hunter)

const STATE_COLORS: Dictionary[Hunter.State, Color] = {
	Hunter.State.AVAILABLE: Color("#34D399"),
	Hunter.State.BUSY: Color("#FBBF24"),
	Hunter.State.UNAVAILABLE: Color("#F87171")
}
const BORDER_COLOR := Color.WHITE
const BORDER_WIDTH := 3
const BORDER_OVERRIDE_NAME := &"border"

var hunter: Hunter:
	set(value):
		assert(hunter == null) # hunter is only meant to be set once
		hunter = value
		icon.texture = load(hunter.face_texture_path)
		hunter.state_changed.connect(_hunter_state_changed)
		get_theme_stylebox(&"panel").bg_color = STATE_COLORS[hunter.state]

@onready var icon: TextureRect = $Icon


func remove_border() -> void:
	get_theme_stylebox(&"panel").set_border_width_all(0)


func _add_border() -> void:
	var style := get_theme_stylebox(&"panel").duplicate(true)

	style.border_color = BORDER_COLOR
	style.set_border_width_all(BORDER_WIDTH)

	add_theme_stylebox_override(&"panel", style)
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if hunter.state == Hunter.State.AVAILABLE:
			hunter_selected.emit(hunter)
			_add_border()


func _hunter_state_changed() -> void:
	print("hunter state changed")
	get_theme_stylebox(&"panel").bg_color = STATE_COLORS[hunter.state]
