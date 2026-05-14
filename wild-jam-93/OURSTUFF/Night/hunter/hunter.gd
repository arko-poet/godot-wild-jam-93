class_name Hunter extends RefCounted

signal state_changed

enum State {AVAILABLE, BUSY, UNAVAILABLE}

var face_texture_path: String
var power: int
var health: int
var state := State.AVAILABLE:
	set(value):
		state = value
		state_changed.emit()
var at_camp := true


func _init(p_face_texture_path: String, p_power = 1, p_health = 2) -> void:
	face_texture_path = p_face_texture_path
	power = p_power
	health = p_health
