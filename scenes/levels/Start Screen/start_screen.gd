extends Node2D

var SIGNAL = "false"

func _on_start_button_pressed():
	SIGNAL = "true"
	

func _on_quit_button_pressed():
	get_tree().quit()
	

var SPEED = 0.2

func _physics_process(delta):
	if SIGNAL == "true":
		position.y += SPEED
		SPEED = 0
		var sprite = $start_button
		while modulate.a > 0:
			sprite.modulate.a -= 0.1
			await get_tree().create_timer(3.0).timeout
		
