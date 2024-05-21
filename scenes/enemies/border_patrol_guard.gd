extends CharacterBody2D


const SPEED = 300.0
var direction = Vector2.RIGHT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity = direction * SPEED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_wall():
		direction.x = direction.x * -1
		velocity.x = direction.x * SPEED

	move_and_slide()