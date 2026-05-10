class_name HunterSlot extends Panel

## this notifies dispatch window which slot user selecter for the hunter
signal hunter_slot_selected(hunter_slot: HunterSlot)

const HOVER_HIGHLIGHT_MODULATE = Color(1.2, 1.2, 1.2)

var hunter: Variant: # TODO decide the type
	set(value):
		hunter = value
		if value != null:
			# TODO set texture here
			_remove_border_highlight()
			pass
	
@onready var bounty_hunter_texture: TextureRect = $Texture


func add_border_highlight() -> void:
	pass
	
	
func _remove_border_highlight() -> void:
	pass


func _on_mouse_entered() -> void:
	modulate = HOVER_HIGHLIGHT_MODULATE


func _on_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if hunter == null:
			hunter_slot_selected.emit(self)
		else:
			# TODO remove bounty hunter from the slot
			pass
