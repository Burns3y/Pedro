extends CharacterBody2D

signal player_died
signal player_killed_guard

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


func _on_player_dies_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		player_died.emit()


func _on_head_jump_region_body_entered(body):
	if body.is_in_group("Player"):
		print("Guard Died")
		queue_free()
