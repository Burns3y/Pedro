extends CanvasLayer

var shop_pressed = false
var ms: int = 0
var s: int = 0
var m: int = 0
var ended: bool = false
var score: int = 0
var score_added = false
func _process(_delta):
	
	#Stops timer if the game is paused or ended
	if $"../..".game_is_paused or $"../../Pedro".ended:
		$Timer.one_shot = true
	else:
		$Timer.one_shot = false
		if $Timer.is_stopped():
			$Timer.start()
	
	#Changes timer when ms gets higher and m gets higher
	if ms > 99:
		s += 1
		ms = 0
	if s > 60:
		m += 1
		s = 0

	if $"../Start_Screen".SIGNAL:
		score_added = false

	#
	if $"../../Pedro".ended:
		if score_added == false:
			score_added = true

func _on_timer_timeout():
	if $"../../Pedro".started == true:
		ms += 5
		var timer = "Timer: " + str(m) + " : " + str(s) + " : " + str(ms)
		$TimerText.text = timer


func _on_start_screen_started():
	ms = 0
	s = 0
	m = 0
	score = 0
	$TimerText.text = "Timer: 0 : 0 : 0"
	$ScoreText.text = "Score: 0"
	
	
	if $Timer:
		$Timer.start()
		$Timer.one_shot = false


func increase_score():
	score += 1
	$ScoreText.text = "Score: " + str(score)


func _on_mute_sfx_pressed():
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus_index, !AudioServer.is_bus_mute(sfx_bus_index))


func _on_mute_music_pressed():
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus_index, !AudioServer.is_bus_mute(music_bus_index))
