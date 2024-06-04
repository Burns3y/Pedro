extends CanvasLayer

var time_spent: int = 0
var ended: bool = false

func _process(_delta):

	if ($Timer.is_stopped() and $"../Start_Screen".SIGNAL) or $"../../Pedro".ended:
		#if paused:
			#print("Paused")
		#elif not paused:
			#print("Not paused")
		$Timer.start()

func _on_timer_timeout():
	if $"../../Pedro".started == true:
		time_spent += 1
		var timer = "Timer: " + str(time_spent)
		$Label.text = timer


func _on_start_screen_started():
	time_spent = 0
	$Label.text = "Timer: 0"

