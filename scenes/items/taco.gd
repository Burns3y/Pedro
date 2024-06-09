extends Area2D

signal taco_collected


func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
		taco_collected.emit()
