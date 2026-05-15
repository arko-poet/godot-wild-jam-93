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
var hunterFaceSeed : Array


func _init(p_face_texture_path: String, p_power = 1, p_health = 2) -> void:
	face_texture_path = p_face_texture_path
	hunterFaceSeed.append(randi_range(0,2)) #head
	hunterFaceSeed.append(randi_range(0,3)) #hat
	hunterFaceSeed.append(randi_range(0,2)) #eye
	hunterFaceSeed.append(randi_range(0,2)) #mouth
	hunterFaceSeed.append(Vector2(randf_range(-6, 5), randf_range(-8, 10)))
	hunterFaceSeed.append(Vector2(hunterFaceSeed[4].x+8, randf_range(hunterFaceSeed[4].y, 27)))
	power = p_power
	health = p_health
