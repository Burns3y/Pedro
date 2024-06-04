extends Node2D

var SIGNAL: bool = false
#var paused: bool = false
signal started

func _on_start_button_pressed():
	SIGNAL = true
	$"../../Pedro".ended = false
	started.emit()

func _on_quit_button_pressed():
	get_tree().quit()

func _physics_process(_delta):
	if $"../../Pedro".ended:
		SIGNAL = false
		position.x = $"../../Pedro".position.x - 545
		$".".modulate.a = 1
		
	elif SIGNAL == true:
		while $".".modulate.a > 0:
			$".".modulate.a -= 0.05
			await get_tree().create_timer(3.0).timeout
		#$start_button.text = "Continue"
		#$quit_button.text = "Restart"
	elif $".".modulate.a < 1:
		#$start_button.text = "Start Game"
		#$quit_button.text = "Quit Game"
		$".".modulate.a = 1
	#if Input.is_action_just_pressed("pause"):
		#paused = true
