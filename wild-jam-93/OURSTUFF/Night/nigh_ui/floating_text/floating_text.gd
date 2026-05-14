extends Node2D

@onready var label: Label = $CenterContainer/Label


func show_text(text: String) -> void:
	label.text = text
	var tween := create_tween()
	
	tween.set_parallel()

	var original_scale := label.scale
	label.scale = original_scale * 0.6
	var new_scale := original_scale * 1.15

	tween.tween_property(label, "scale", new_scale, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", original_scale, 0.10).set_delay(0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position", Vector2(0, -64), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 1)
	
	tween.finished.connect(queue_free)
