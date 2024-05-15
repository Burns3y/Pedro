extends Node2D

var button_initial_position = 100


func _ready():
	# Store the initial position of the button
	button_initial_position = $Button.rect_positio

func _on_start_button_pressed():
	$start_button.rect_min_size.y += 100
	print("pressed started")
	button_initial_position.y += 100
	$Button.rect_position = button_initial_position


func _on_quit_button_pressed():
	get_tree().quit()
