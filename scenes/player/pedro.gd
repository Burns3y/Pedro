extends CharacterBody2D

signal player_died

var NO_WALL_JUMP = 0
var SPEED = 13000
const JUMP_VELOCITY = -600
var started: bool = false
var ended: bool = false
var is_paused: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_start_screen_started():
	started = true
	position = Vector2(304, 469)


func _physics_process(delta):
	if position.y >= 700 and $"..".level == 2:
		$Camera2D.limit_bottom = 2000
		$Camera2D.position_smoothing_speed = 1

	elif position.y > 550 and position.x < 600:
		$Camera2D.limit_bottom = 2000
		$Camera2D.position_smoothing_speed = 1

	else:
		$Camera2D.limit_bottom = 720
		$Camera2D.position_smoothing_speed = 5
	
	if started and not ended and not $"..".game_is_paused:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta + 10

		## Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction and NO_WALL_JUMP == 0:
			velocity.x = direction * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


		#JUMPING MECHANICS
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Wall jump
		elif Input.is_action_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 5500:
			velocity.y = JUMP_VELOCITY 

		#Flipping image depending on direction
		if direction == -1:
			$Pedroanimation.flip_h = true
			$Pedroanimation.offset.x = -18
		elif direction == 1:
			$Pedroanimation.flip_h = false
			$Pedroanimation.offset.x = 0
			
		move_and_slide()
		
		if position.x > 5714.5 and is_on_floor():
			ended = true
			$"..".restart()


func _on_player_died():
	position = Vector2(304, 469)
	started = false



#Level 1 pedro cam bottom 720
