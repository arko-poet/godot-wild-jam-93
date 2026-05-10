class_name Hunter extends RefCounted

var face_texture
var power: int
var health: int


func _init(face_texture_path: String) -> void:
	face_texture = load(face_texture_path)
