extends CanvasLayer

var ms: int = 0
var s: int = 0
var m: int = 0
var ended: bool = false
var score: int = 0

func _process(_delta):
	
	if $"../..".game_is_paused:
		print("one shot timer")
		$Timer.one_shot = true
	else:
		$Timer.one_shot = false
	
	if ms > 99:
		s += 1
		ms = 0
	if s > 60:
		m += 1
		s = 0
		
		get_tree()

	if ($Timer.is_stopped() and $"../Start_Screen".SIGNAL) or $"../../Pedro".ended:
		if not $"../..".game_is_paused:
			$Timer.start()

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
	
func increase_score():
	score += 1
	$ScoreText.text = "Score: " + str(score)
