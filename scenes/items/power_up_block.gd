extends Sprite2D

#Creates signal for powerup
signal player_power_up

func power_up_block_touched(body):
	#If the player entered, plays sound and emits the signal
	if body.is_in_group("Player"):
		print("player entered")
		$AudioStreamPlayer_powerup.play()
		player_power_up.emit()
