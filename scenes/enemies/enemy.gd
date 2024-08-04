extends CharacterBody2D

#Creates signals for guards and player dying
signal player_died
signal player_killed_enemy(position)

var is_paused: bool = false

#Creates movement variables
const SPEED = 125.0
var direction = Vector2.RIGHT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var frame = 0
var dying = false


func _ready():
	velocity = direction * SPEED


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
			$FullBearAnim.flip_h = false
			$FullBearAnim.offset.x = 0
		elif direction.x == 1:
			$FullBearAnim.flip_h = true
			$FullBearAnim.offset.x = -9
		
		
		move_and_slide()
		
	if $FullBearAnim.modulate.a == 0:
		queue_free()

#Emits a signal when the player hits the side, connects to the player through the level scene
func _on_player_dies_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		player_died.emit()
 
#When the player jumps on the head of the enemy, the enemy dies.
func _on_head_jump_region_body_entered(body):
	if body.is_in_group("Player"):
		dying = true
		player_killed_enemy.emit(position)
		
		#Remove hitboxes so Pedro doesn't stand on invisible bear
		for hitbox in $".".get_children():
			if hitbox is CollisionShape2D or hitbox is Area2D:
				hitbox.queue_free()
		
		#Makes the bear squish and fade out
		$AnimationPlayer.play("Bear_dying")
		var tween = get_tree().create_tween()
		tween.tween_property($FullBearAnim, "modulate", Color(0.439, 0.306, 0.231, 0), 2)


func pause(game_is_paused):
	is_paused = game_is_paused
