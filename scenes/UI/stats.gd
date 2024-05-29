extends CanvasLayer

var time_spent: int = 0


func _process(_delta):
	
	
	if $Timer.is_stopped() and $"../Start_Screen".SIGNAL:
		$Timer.start()

	elif not $"../Start_Screen".SIGNAL:
		time_spent = 0
		$Label.text = "Timer: 0"


func _on_timer_timeout():
	time_spent += 1
	var timer = "Timer: " + str(time_spent)
	$Label.text = timer

