extends CanvasLayer
var SIGNAL: bool

signal started

func _ready():
	if Global.game_started:
		starting_game()

#Removes all enemies and tacos, disables the buttons, unpauses the game
func starting_game():
	#Resets the game
	Global.game_started = true
	$"../../Pedro".ended = false
	$"../..".remove_enemies()
	$"../..".remove_tacos()
	$"../..".game_is_paused = false
	SIGNAL = true
	disable_buttons(true)
	
	#Emits started() signal
	started.emit()


###When the buttons are pressed the game starts
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
	#If the game has ended
	if $"../../Pedro".ended:
		#Enable buttons buttons
		disable_buttons(false)
		SIGNAL = false
		#Makes the start screen visable
		$Panel.modulate.a = 1
		#Changes the text to next level
		if $"../..".current_level != 2:
			$Panel/start_button.text = "Next Level"
		
	#If the game is running, ensures the panel doesn't appear
	elif SIGNAL == true and not $"../..".game_is_paused:
		if $Panel.modulate.a > 0:
			$Panel.modulate.a -= 1.5 * delta
		$Panel/start_button.text = "Start Game"
	
	#Makes the panel appear
	elif $Panel.modulate.a < 1:
		$Panel.modulate.a = 1
	
	#If the game is paused
	if $"../..".game_is_paused and not $"../../Pedro".ended:
		#Enables buttons
		$Panel.modulate.a = 1
		disable_buttons(false)
		$Panel/start_button.text = "Restart"

#Enable buttons function
func disable_buttons(enable_or_disable):
	for button in $Panel.get_children():
		if button is Button:
			button.disabled = enable_or_disable
