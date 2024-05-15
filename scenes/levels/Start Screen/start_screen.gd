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
		SPEED = -1000
