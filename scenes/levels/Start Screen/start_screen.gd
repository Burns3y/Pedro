extends Node2D

var SIGNAL = "false"

func _on_start_button_pressed():
	SIGNAL = "true"
	

func _on_quit_button_pressed():
	get_tree().quit()

func _physics_process(delta):
	if SIGNAL == "true":
		while $Panel.modulate.a > 0:
			$Panel.modulate.a -= 0.05
			$start_button.modulate.a -= 0.05
			$quit_button.modulate.a -= 0.05
			$Logo.modulate.a -= 0.05
			await get_tree().create_timer(3.0).timeout
		
