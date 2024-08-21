extends Sprite2D

#Creates signals for guards and player dying
signal player_power_up

func power_up_block_touched(body):
	if body.is_in_group("Player"):
		print("player entered")
		$AudioStreamPlayer_powerup.play()
		player_power_up.emit()
