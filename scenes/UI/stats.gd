extends CanvasLayer

var ms: int = 0
var s: int = 0
var m: int = 0
var ended: bool = false

func _process(_delta):
	
	
	if ms > 99:
		s += 1
		ms = 0
	if s > 60:
		m += 1
		s = 0

	if ($Timer.is_stopped() and $"../Start_Screen".SIGNAL) or $"../../Pedro".ended:
		#if paused:
			#print("Paused")
		#elif not paused:
			#print("Not paused")
			
		$Timer.start()

func _on_timer_timeout():
	if $"../../Pedro".started == true:
		ms += 5
		var timer = "Timer: " + str(m) + " : " + str(s) + " : " + str(ms)
		$Label.text = timer


func _on_start_screen_started():
	ms = 0
	s = 0
	m = 0
	$Label.text = "Timer: 0 : 0 : 0"

