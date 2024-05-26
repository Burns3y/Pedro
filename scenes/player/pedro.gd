extends CharacterBody2D

var NO_WALL_JUMP = 0
var SPEED = 13000
const JUMP_VELOCITY = -600
var started: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_start_screen_started():
	started = true

func _physics_process(delta):
	if started == true:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta + 10
#
		## Get the input direction and handle the movement/deceleration.
		## As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction and NO_WALL_JUMP == 0:
			velocity.x = direction * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if is_on_wall_only() and position.x < 5500:
			#temproarily disables movement for player
			NO_WALL_JUMP = 1
			velocity.x = move_toward(velocity.x, 0, SPEED)
			await get_tree().create_timer(0.000001).timeout
			NO_WALL_JUMP = 0
		#jumping mechancis
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Wall jump
		elif Input.is_action_just_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 5500:
			velocity.y = JUMP_VELOCITY 
			
			
		move_and_slide()


#func _on_border_patrol_guard_player_died():
	#print("Pedro died")
	#
#
#
#func _on_left_area_body_entered(body):
	#print("left", body)
	#disable_left = true
#
#
#func _on_right_area_body_entered(body):
	#print("right", body)
	#disable_right = true
