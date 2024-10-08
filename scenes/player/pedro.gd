extends CharacterBody2D

#Signals
signal player_died
signal player_power_up

#Movement and wall jump
var NO_WALL_JUMP = 0
var SPEED = 13000
var JUMP_VELOCITY = -600
var WAS_ON_CEILING = false
var ceiling_calc = 0
var head_hit_time = 5

#Powerup
var power_up = false

#Game operations
var is_paused: bool = false
var started: bool = false
var ended: bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#When game starts
func _on_start_screen_started():
	#Ends game if the position is high
	if position.x > 4500:
		ended = true
		#Starts game and resets position
	started = true
	position = Vector2(304, 469)
	power_up = false

#Runs every frame of the game
func _physics_process(delta):
	#Checks current scene
	var scene_name = str(get_tree().get_current_scene().get_name())
	var current_level = int(scene_name[scene_name.length() - 1])
	
	#If the game hasn't ended
	if not ended:
		#If is in cave
		#If is in level 2
		if position.y >= 700 and current_level == 2:
			#Changes camera
			$Camera2D.limit_bottom = 2000
			$Camera2D.position_smoothing_speed = 2
			$Camera2D.zoom = Vector2(1.5, 1.5)
			
			#Darkens scene
			$"../Lvl2Map/DirectionalLight2D".energy = 0.8
		
		#If not in cave
		else:
			#Resets camera
			$Camera2D.limit_bottom = 720
			$Camera2D.position_smoothing_speed = 5
			$Camera2D.zoom = Vector2(1, 1)
			
			#Lightens scene
			if current_level == 2:
				$"../Lvl2Map/DirectionalLight2D".energy = 0

		#If player falls off map
		if position.y > 2000:
			#Plays death sound
			$Audio/AudioStreamPlayer_death.play()
			#Restarts
			position = Vector2(304, 469)
			started = false
			$"..".restart()
			$"../UI/Stats".ended = true
		
		#If the game is running
		if started and not ended and not $"..".game_is_paused:
			# Add the gravity.
			if not is_on_floor():
				#Adds gravity
				velocity.y += gravity * delta + 10
				#Changes the animation frames
				$PedroIdle.modulate.a = 0
				$Pedroanimation.modulate.a = 0
				$PedroJumping.modulate.a = 1
			
			#Runs head hitting function if Pedro is on ceiling
			if is_on_ceiling_only():
				head_hitting()
			
			#power up code (increases jump and speed)
			if power_up == true:
				JUMP_VELOCITY = -700
				SPEED = 20000
			else:
				SPEED = 13000
				JUMP_VELOCITY = -600
				
			## Get the input direction and handle the movement/deceleration.
			var direction = Input.get_axis("left", "right")
			
			#If not moving
			if direction and NO_WALL_JUMP == 0:
				velocity.x = direction * SPEED * delta
				if is_on_floor():
					#Plays footsteps soundtrack and changes the frame
					if not $Audio/AudioStreamPlayer_footsteps.playing:
						$Audio/AudioStreamPlayer_footsteps.play()
					$PedroIdle.modulate.a = 0
					$Pedroanimation.modulate.a = 1
					$PedroJumping.modulate.a = 0
				else:
					#Stops footsteps soundtrack
					if $Audio/AudioStreamPlayer_footsteps.playing:
						$Audio/AudioStreamPlayer_footsteps.stop()
			else:
				#Stops footsteps sound if off ground
				if $Audio/AudioStreamPlayer_footsteps.playing:
					$Audio/AudioStreamPlayer_footsteps.stop()
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
				if is_on_floor():
					$Pedroanimation.modulate.a = 0
					$PedroIdle.modulate.a = 1
					$PedroJumping.modulate.a = 0
			
			#JUMPING MECHANICS
			# Handle jump.
			if Input.is_action_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				$Audio/AudioStreamPlayer_jump.play()

			# Wall jump
			if Input.is_action_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 5525:
				velocity.y = JUMP_VELOCITY
				$Audio/AudioStreamPlayer_jump.play()
			
			#Wall jump tutorial level
			elif $"..".level == 0 and Input.is_action_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 4500:
				velocity.y = JUMP_VELOCITY
				$Audio/AudioStreamPlayer_jump.play()

			#Flipping image depending on direction
			if direction == -1:
				$Pedroanimation.flip_h = true
				$PedroIdle.flip_h = true
				$PedroJumping.flip_h = true
				$PedroIdle.offset.x = -15
			elif direction == 1:
				$Pedroanimation.flip_h = false
				$PedroIdle.flip_h = false
				$PedroJumping.flip_h = false
				$PedroIdle.offset.x = 0
			move_and_slide()
			
			#Ends game if Pedro's position is past the ending barrier
			if position.x > 5711 and is_on_floor():
				end_level()
			#Ends game if Pedro's position is past the ending barrier (tutorial)
			elif $"..".level == 0 and position.x > 4712 and is_on_floor():
				end_level()

func head_hitting():
	#Increases speed if Pedro's head hit the ceiling
	for i in range(500):
		if ceiling_calc < head_hit_time:
			while SPEED != 20000:
				SPEED += 1
				if is_on_ceiling():
					break
			await get_tree().create_timer(0.05).timeout
			ceiling_calc += 1
		if ceiling_calc == head_hit_time:
			SPEED = 13000
			ceiling_calc = 0
			break
		if is_on_ceiling():
			ceiling_calc = 0
			break
		if ceiling_calc > head_hit_time:
			ceiling_calc = 0
			break
			
			
			
func _on_player_died():
	#Plays death sound
	$Audio/AudioStreamPlayer_death.play()
	#Resets position
	position = Vector2(304, 469)
	started = false
	power_up = false

func end_level():
	#Ends and restarts game
	$"../AudioStreamPlayer_music".stop()
	$Audio/AudioStreamPlayer_level_complete.play()
	ended = true
	$"..".restart()
	#Increases level
	if $"..".level < 2:
		$"..".level += 1

func _on_power_up_player_power_up():
	#Powers player up :O
	power_up = true
