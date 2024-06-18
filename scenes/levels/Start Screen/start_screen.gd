extends CanvasLayer
var SIGNAL: bool = false

signal started

func _on_start_button_pressed():
	$"../..".remove_enemies()
	$"../..".remove_tacos()
	SIGNAL = true
	$"../..".game_is_paused = false
	$Panel/quit_button.disabled = true
	$Panel/start_button.disabled = true
	started.emit()

func _on_quit_button_pressed():
	get_tree().quit()

func _process(_delta):
	if $"../../Pedro".ended:
		SIGNAL = false
		$Panel.modulate.a = 1
		
	elif SIGNAL == true and not $"../..".game_is_paused:
		
		while $Panel.modulate.a > 0:
			$Panel.modulate.a -= 0.05
			await get_tree().create_timer(3.0).timeout
		$Panel/start_button.text = "Start Game"

	elif $Panel.modulate.a < 1:

		$Panel.modulate.a = 1

	if $"../..".game_is_paused and not $"../../Pedro".ended:
		$Panel.modulate.a = 1
		$Panel/start_button.disabled = false
		$Panel/start_button.text = "Restart"
		$Panel/quit_button.disabled = false
		
