extends CanvasLayer
var SIGNAL: bool

signal started

#Removes all enemies and tacos, disables the buttons, unpauses the game
func starting_game():
	$"../../Pedro".ended = false
	$"../..".remove_enemies()
	$"../..".remove_tacos()
	$"../..".game_is_paused = false
	SIGNAL = true
	disable_buttons(true)
	
	#Emits started() signal
	started.emit()

func _on_start_button_pressed():
	starting_game()

func _on_tutorial_button_pressed():
	$"../..".level = 0
	starting_game()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_level_1_button_pressed():
	$"../..".level = 1
	starting_game()


func _process(delta):
	
	if $"../../Pedro".ended:
		disable_buttons(false)

		if $"../..".level < 2:
			$"../..".level += 1
		
		SIGNAL = false
		$Panel.modulate.a = 1
		if $"../..".level != 2:
			$Panel/start_button.text = "Next Level"
		
		
	elif SIGNAL == true and not $"../..".game_is_paused:
		if $Panel.modulate.a > 0:
			$Panel.modulate.a -= 1.5 * delta
		$Panel/start_button.text = "Start Game"

	elif $Panel.modulate.a < 1:
		$Panel.modulate.a = 1

	if $"../..".game_is_paused and not $"../../Pedro".ended:
		$Panel.modulate.a = 1

		disable_buttons(false)
		$Panel/start_button.text = "Restart"

func disable_buttons(enable_or_disable):
	for button in $Panel.get_children():
		if button is Button:
			button.disabled = enable_or_disable
