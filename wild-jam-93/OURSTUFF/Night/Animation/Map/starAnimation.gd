extends CharacterBody2D
class_name AnimationStar
#@onready var stage_c_oach_animation: Node2D = $StageCOachAnimation

@export var speed = 500

##Target position to move toward
var target
var has_impact_ground: bool = false

signal impact_ground

func _process(delta: float) -> void:

	var dir
	if not target:
		dir = (get_global_mouse_position() - global_position).normalized()
	else:
		dir =  (target - global_position).normalized()
	if (global_position.distance_to(get_global_mouse_position()) < 5 and not target) or (target and global_position.distance_to(target) < 20):
		speed = 100
	if (global_position.distance_to(get_global_mouse_position()) < 5 and not target) or (target and global_position.distance_to(target) < 5):
		if not has_impact_ground:
			has_impact_ground = true
			
			$CPUParticles2D.emitting = false
			$IMPACT.emitting = true
			$Line2D.stop = true
			$Line2D2.stop = true
			impact_ground.emit()
		return

	velocity = dir * speed

	
	#stage_c_oach_animation.animate(dir)
	
	move_and_slide()
	
