extends CharacterBody2D


var SPEED = 13000
const JUMP_VELOCITY = -600
var started: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_start_screen_started():
	started = true
	print("Started")

func _physics_process(delta):
	var NO_WALL_JUMP = false
	if started == true:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta + 10

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if NO_WALL_JUMP == true:
			await get_tree().create_timer(0.5).timeout
		elif NO_WALL_JUMP == false:
			if direction:
				velocity.x = direction * SPEED * delta
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Wall jump
		elif Input.is_action_just_pressed("jump") and is_on_wall_only() and velocity.y >= -200 and position.x >= 5500:
			velocity.y = JUMP_VELOCITY 
		elif Input.is_action_just_pressed("jump") and is_on_wall_only() and position.x <= 5500:
			velocity.y += gravity * delta + 500
			velocity.x = -100
			NO_WALL_JUMP = true

		move_and_slide()


func _on_border_patrol_guard_player_died():
	print("Pedro died")
	
