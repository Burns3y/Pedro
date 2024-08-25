extends Area2D

signal taco_collected

func _on_body_entered(body):
	#If player ate taco
	if body.is_in_group("Player"):
		$AudioStreamPlayer_taco.play()
		#Removes all nodes other than sound and timer
		for child in $".".get_children():
			if child != $AudioStreamPlayer_taco and child != $Timer:
				child.queue_free()
		#Emits signal
		taco_collected.emit()

#Disappears
func _on_timer_timeout():
	queue_free()
