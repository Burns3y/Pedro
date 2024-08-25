extends CharacterBody2D

#Creates signals for guards and player dying
signal player_died
signal player_killed_enemy(position)

#If the game is paused
var is_paused: bool = false
#If the dying animation and sound is being played
var dying = false

#Creates movement variables
const SPEED = 125.0
var direction = Vector2.RIGHT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#When the bear is instantiated
func _ready():
	#Starts the bear
	velocity = direction * SPEED


#Called every frame
func _physics_process(delta):
	# Add the gravity.
	if not is_paused and not dying:
		if not is_on_floor():
			velocity.y += gravity * delta
			
		#Changes direction if the guard touches a wall
		if is_on_wall():
			direction.x = direction.x * -1
			velocity.x = direction.x * SPEED
		
		#Changes icon direction when it hits a wall so character points in the right direction
		if direction.x == -1:
			$"Bear-more-frames-edited".flip_h = false
			$"Bear-more-frames-edited".offset.x = 0
		elif direction.x == 1:
			$"Bear-more-frames-edited".flip_h = true
			$"Bear-more-frames-edited".offset.x = -18
		
		
		move_and_slide()

#Emits a signal when the player hits the side, connects to the player through the level scene
func _on_player_dies_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		player_died.emit()
 
#When the player jumps on the head of the enemy, the enemy dies.
func _on_head_jump_region_body_entered(body):
	if body.is_in_group("Player"):
		#Plays the audio, emits the signal and ensures bear doesn't fall through floor
		$AudioStreamPlayer_death_bear.play()
		dying = true
		player_killed_enemy.emit(position)
		
		#Remove hitboxes so Pedro doesn't stand on invisible bear
		for hitbox in $".".get_children():
			if hitbox is CollisionShape2D or hitbox is Area2D:
				hitbox.queue_free()
		
		#Makes the bear squish and fade out
		$Timer.start()
		$AnimationPlayer.play("Bear_dying")
		var tween = get_tree().create_tween()
		tween.tween_property($"Bear-more-frames-edited", "modulate", Color(0.439, 0.306, 0.231, 0), 2)

#Pauses the enemy
func pause(game_is_paused):
	is_paused = game_is_paused

#Deletes the bear once the timer runs out
func _on_timer_timeout():
	queue_free()
