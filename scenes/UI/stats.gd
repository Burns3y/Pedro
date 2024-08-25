extends CanvasLayer

var shop_pressed = false
var ms: int = 0
var s: int = 0
var m: int = 0
var ended: bool = false
var score: int = 0

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

#When the timer stops
func _on_timer_timeout():
	#If the game has started
	if $"../../Pedro".started == true:
		#Add 5 seconds to the display text
		ms += 5
		var timer = "Timer: " + str(m) + " : " + str(s) + " : " + str(ms)
		$TimerText.text = timer


#When the game has started
func _on_start_screen_started():
	#Resets timer
	ms = 0
	s = 0
	m = 0
	score = 0
	$TimerText.text = "Timer: 0 : 0 : 0"
	$ScoreText.text = "Score: 0"
	
	#Only calls the timer if it exists
	if $Timer:
		$Timer.start()
		$Timer.one_shot = false


func increase_score():
	#Increases score (taco count)
	score += 1
	$ScoreText.text = "Score: " + str(score)


#SOUND EFFECTS
func _on_mute_sfx_pressed():
	#Makes the sound effects' mute status the opposite of what it is currently, muting or unmuting it.
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx_bus_index, !AudioServer.is_bus_mute(sfx_bus_index))


#MUSIC
func _on_mute_music_pressed():
	#Makes the music's mute status the opposite of what it is currently, muting or unmuting it.
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus_index, !AudioServer.is_bus_mute(music_bus_index))
