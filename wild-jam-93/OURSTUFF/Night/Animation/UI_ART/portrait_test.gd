class_name Portrait extends Panel

@onready var head: TextureRect = $HEAD
@onready var eye: TextureRect = $EYE
@onready var mouth: TextureRect = $MOUTH
@onready var hat: TextureRect = $HAT

var size_res = 64

#func _ready() -> void:
	#_init_random_portrait()

func _init_random_portrait() -> void:
	random_head()
	random_hat()
	random_eye()
	random_mouth()
	
	#placement
	eye.position = Vector2(randf_range(-6, 5), randf_range(-8, 10))
	mouth.position = Vector2(eye.position.x+8, randf_range(eye.position.y, 27))

func _init_seeded_portrait(seed: Array):
	head.texture.set_region(Rect2(Vector2(size_res*seed[0], 0), Vector2(size_res, size_res)))
	hat.texture.set_region(Rect2(Vector2(size_res*seed[1], size_res), Vector2(size_res, size_res)))
	eye.texture.set_region(Rect2(Vector2(size_res*seed[2], size_res * 2), Vector2(size_res, size_res)))
	mouth.texture.set_region(Rect2(Vector2(size_res*seed[3], size_res * 3), Vector2(size_res, size_res)))
	eye.position = seed[4]
	mouth.position = seed[5]


func random_head():
	var rand = randi_range(0, 2)
	head.texture.set_region(Rect2(Vector2(size_res*rand, 0), Vector2(size_res, size_res)))

func random_hat():
	var rand = randi_range(0, 3)
	hat.texture.set_region(Rect2(Vector2(size_res*rand, size_res), Vector2(size_res, size_res)))
	

func random_eye():
	var rand = randi_range(0, 2)
	eye.texture.set_region(Rect2(Vector2(size_res*rand, size_res * 2), Vector2(size_res, size_res)))
	
func random_mouth():
	var rand = randi_range(0, 2)
	mouth.texture.set_region(Rect2(Vector2(size_res*rand, size_res * 3), Vector2(size_res, size_res)))
