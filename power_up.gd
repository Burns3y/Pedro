extends Sprite2D

#Creates signals for guards and player dying
signal player_died

#Emits a signal when the player hits the side, connects to the player through the level scene
func power_up_entered(body):
	if body.is_in_group("Player"):
		print("in me")

