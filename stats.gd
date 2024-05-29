extends Area2D

var SPEED = 13000
var time_spent: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Timer.is_stopped() and $"../../Start_Screen".SIGNAL:
		$Timer.start()
		
	elif not $"../../Start_Screen".SIGNAL:
		time_spent = 0
		$TextEdit.text = "Timer: 0"


func _on_timer_timeout():
	time_spent += 1
	var timer = "Timer: " + str(time_spent)
	$TextEdit.text = timer
