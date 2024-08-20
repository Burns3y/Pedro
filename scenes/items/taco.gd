extends Area2D

signal taco_collected

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$AudioStreamPlayer_taco.play()
		for child in $".".get_children():
			if child != $AudioStreamPlayer_taco and child != $Timer:
				child.queue_free()
		taco_collected.emit()


func _on_timer_timeout():
	queue_free()
