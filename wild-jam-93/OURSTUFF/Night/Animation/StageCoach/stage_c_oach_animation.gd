extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	$Line2D._root = $Point_line2D
	$Line2D2._root = $Point_Line2D2

## Play the moving animation. Intended to be played inside _process and need the moving direction (normalized)
func animate(dir: Vector2):
	if not dir:
		print("No direction for animation")
		return
	
	$CPUParticles2D.direction = -dir
	
	var x = dir.x
	var y = dir.y

	# N -> North, S -> South, E -> East, 0 -> West (i use O since in French West is Ouest i forgot to took the english one)
	# 1. Diagonal 
	if x > 0.3 and y > 0.3:
		anim.play("SE")
		return
	if x < -0.3 and y > 0.3:
		anim.play("SO")
		return
	if x > 0.3 and y < -0.3:
		anim.play("NE")
		return
	if x < -0.3 and y < -0.3:
		anim.play("NO")
		return

	# 2. AXES
	if abs(x) > abs(y):
		if x > 0:
			anim.play("E")
		else:
			anim.play("O")
	else:
		if y > 0:
			anim.play("S")
		else:
			anim.play("N")
