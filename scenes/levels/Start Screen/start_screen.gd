extends CanvasLayer
#SIGNAL checks if the game has started
var SIGNAL: bool = false

signal started

#Removes all enemies and tacos, disables the buttons, unpauses the game
func starting_game():
	print($"../..".current_level)
	$"../..".remove_enemies()
	$"../..".remove_tacos()
	SIGNAL = true
	$"../..".game_is_paused = false
	for i in $Panel.get_children():
		if i is Button:
			i.disabled = true
	
	#Emits started() signal
	started.emit()
	
func _on_start_button_pressed():
	starting_game()

func _on_tutorial_button_pressed():
	$"../../Pedro".ended = false
	$"../..".current_level = 0
	starting_game()


func _on_level_1_button_pressed():
	$"../../Pedro".ended = false
	$"../..".current_level = 1
	call_deferred("starting_game")


func _on_quit_button_pressed():
	get_tree().quit()


func _process(_delta):
	if $"../../Pedro".ended:
		print("Ended is true")
		SIGNAL = false
		$Panel.modulate.a = 1
		if $"../..".current_level < 2:
			$Panel/start_button.text = "Next Level"

	elif SIGNAL == true and not $"../..".game_is_paused:
		print("started and not paused")
		
		while $Panel.modulate.a > 0:
			$Panel.modulate.a -= 0.05
			await get_tree().create_timer(3.0).timeout
		$Panel/start_button.text = "Start Game"

	elif $Panel.modulate.a < 1:
		print("modulated to 1")

		$Panel.modulate.a = 1

	if $"../..".game_is_paused and not $"../../Pedro".ended:
		$Panel.modulate.a = 1
		print("paused")

		for i in $Panel.get_children():
			if i is Button:
				i.disabled = false
		$Panel/start_button.text = "Restart"
