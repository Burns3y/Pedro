extends Node2D



func _on_start_button_pressed():
	#$start_button.rect_position.y = 300
	print("pressed started")


func _on_quit_button_pressed():
	get_tree().quit()
