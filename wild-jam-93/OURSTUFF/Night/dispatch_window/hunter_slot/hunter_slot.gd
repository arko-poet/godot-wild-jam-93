class_name HunterSlot extends Panel
# TODO This needs to be renamed to StageCoach slot

## this notifies dispatch window which slot user selecter for the hunter
signal hunter_slot_selected(hunter_slot: HunterSlot)
signal hunter_removed(hunter: Hunter)

const HOVER_HIGHLIGHT_MODULATE = Color(1.2, 1.2, 1.2)

var hunter: Hunter:
	set(value):
		hunter = value
		if value != null:
			_hunter_texture.texture = hunter.texture
			_remove_border_highlight()
		else:
			_hunter_texture.texture = null
	
@onready var _hunter_texture: TextureRect = $Texture


#func _ready() -> void:
	#add_border_highlight()


func add_border_highlight() -> void:
	var style = get_theme_stylebox(&"panel").duplicate(true)

	style.border_color = Color.LIME_GREEN
	style.border_width_left   = 1
	style.border_width_right  = 1
	style.border_width_top    = 1
	style.border_width_bottom = 1

	style.corner_radius_top_left = 1
	style.corner_radius_top_right = 1
	style.corner_radius_bottom_left = 1
	style.corner_radius_bottom_right = 1

	add_theme_stylebox_override(&"panel", style)
	
	
func _remove_border_highlight() -> void:
	remove_theme_stylebox_override(&"panel")


func _on_mouse_entered() -> void:
	modulate = HOVER_HIGHLIGHT_MODULATE


func _on_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if hunter == null:
			hunter_slot_selected.emit(self)
		else:
			hunter_removed.emit(hunter)
			hunter = null
