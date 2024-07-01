extends CharacterBody2D

signal player_died

var NO_WALL_JUMP = 0
var SPEED = 13000
const JUMP_VELOCITY = -600
var started: bool = false
var ended: bool = false
var is_paused: bool = false
var WAS_ON_CEILING = false
var ceiling_calc = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_start_screen_started():
	started = true
	position = Vector2(304, 469)

func _physics_process(delta):
	#If player falls off map
	if position.y > 2000:
		position = Vector2(304, 469)
		started = false
		$"..".restart()
		$"../UI/Stats".ended = true

	#If is in cave
	if position.y >= 700 and $"..".level == 2:
		#Changes camera
		$Camera2D.limit_bottom = 2000
		$Camera2D.position_smoothing_speed = 2
		$Camera2D.zoom = Vector2(1.5, 1.5)
		
		#Darkens scene
		while $"../Tilemaps/Lvl2Map/DirectionalLight2D".energy < 0.8:
			if position.y >= 700 and $"..".level == 2:
				$"../Tilemaps/Lvl2Map/DirectionalLight2D".energy += 0.1
				await get_tree().create_timer(3.0).timeout
			
	#If is in cave
	elif position.y > 550 and position.x < 600:
		#Changes camera
		$Camera2D.limit_bottom = 2000
		$Camera2D.position_smoothing_speed = 2
		#Darkens scene
		$"../Tilemaps/Lvl2Map/DirectionalLight2D".energy = 0.8
	
	#If not in cave
	else:
		$Camera2D.limit_bottom = 720
		$Camera2D.position_smoothing_speed = 5
		$Camera2D.zoom = Vector2(1, 1)
		#Lightens scene
		$"../Tilemaps/Lvl2Map/DirectionalLight2D".energy = 0
	
	if started and not ended and not $"..".game_is_paused:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta + 10
			$PedroIdle.modulate.a = 0
			$Pedroanimation.modulate.a = 0
			$PedroJumping.modulate.a = 1
			
		if is_on_ceiling_only():
			head_hitting()

		## Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction and NO_WALL_JUMP == 0:
			velocity.x = direction * SPEED * delta
			if is_on_floor():
				$PedroIdle.modulate.a = 0
				$Pedroanimation.modulate.a = 1
				$PedroJumping.modulate.a = 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				$Pedroanimation.modulate.a = 0
				$PedroIdle.modulate.a = 1
				$PedroJumping.modulate.a = 0


		#JUMPING MECHANICS
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Wall jump
		if Input.is_action_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 5500:
			velocity.y = JUMP_VELOCITY 

		elif $"..".level == 0 and Input.is_action_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 4500:
			velocity.y = JUMP_VELOCITY

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
		
		if position.x > 5711 and is_on_floor():
			ended = true
			$"..".restart()
		elif $"..".level == 0 and position.x > 4712 and is_on_floor():
			ended = true
			$"..".restart()
			
			#WAS_ON_CEILING = true
			#ceiling_calc = 1
		#else:
			#ceiling_calc = 0
			#await get_tree().create_timer(1).timeout
			#if ceiling_calc == 0:
				#SPEED = 13000
func head_hitting():
	if true:
		for i in range(500):
			if ceiling_calc < 20:
				SPEED = 30000
				await get_tree().create_timer(0.05).timeout
				ceiling_calc += 1
			if ceiling_calc == 20:
				SPEED = 13000
				ceiling_calc = 0
				break
			if is_on_ceiling():
				ceiling_calc = 0
				break
			if ceiling_calc > 20:
				ceiling_calc = 0
				break

func _on_player_died():
	position = Vector2(304, 469)
	started = false
