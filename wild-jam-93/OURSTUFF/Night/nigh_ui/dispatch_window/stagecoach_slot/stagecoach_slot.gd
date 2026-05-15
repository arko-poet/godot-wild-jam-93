class_name StagecoachSlot extends Panel
# TODO This needs to be renamed to StageCoach slot

## this notifies dispatch window which slot user selecter for the hunter
signal hunter_slot_selected(stagecoach_slot: StagecoachSlot)
signal hunter_removed(p_hunter: Hunter)

const portrait = preload("res://OURSTUFF/Night/Animation/UI_ART/portrait_test.tscn")

const HOVER_HIGHLIGHT_MODULATE = Color(1.2, 1.2, 1.2)

var hunter: Hunter:
	set(value):
		hunter = value
		if value != null:
			var temp = portrait.instantiate()
			add_child(temp)
			temp._init_seeded_portrait(hunter.hunterFaceSeed)
			remove_border_highlight()
			if hunter.state == Hunter.State.AVAILABLE:
				hunter.state = Hunter.State.BUSY
		else:
			for i in get_children():
				i.queue_free()
	
@onready var _hunter_texture: TextureRect = $Texture


#func _ready() -> void:
	# just a TEST
	#add_border_highlight()


func add_border_highlight() -> void:
	var style := get_theme_stylebox(&"panel").duplicate(true)

	style.border_color = Color.LIME_GREEN
	style.set_border_width_all(1)
	style.set_corner_radius_all(1)

	add_theme_stylebox_override(&"panel", style)
	
	
func remove_border_highlight() -> void:
	remove_theme_stylebox_override(&"panel")


func _on_mouse_entered() -> void:
	modulate = HOVER_HIGHLIGHT_MODULATE


func _on_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if hunter == null:
			hunter_slot_selected.emit(self)
		elif hunter.at_camp:
			print(hunter.at_camp)
			hunter_removed.emit(hunter)
			hunter = null
