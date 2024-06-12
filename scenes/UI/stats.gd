extends CanvasLayer

var ms: int = 0
var s: int = 0
var m: int = 0
var score: int = 0

func _process(delta):
	if ms > 100:
		s += 1
		ms = 0
	if s > 60:
		m += 1
		s = 0

		ms += 100 * delta
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




