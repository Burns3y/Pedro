extends CharacterBody2D

#Creates signals for guards and player dying
signal player_died
signal player_killed_enemy(position)

var is_paused: bool = false

#Creates movement variables
const SPEED = 150.0
var direction = Vector2.RIGHT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity = direction * SPEED


func _physics_process(delta):
	# Add the gravity.
	if not is_paused:
		if not is_on_floor():
			velocity.y += gravity * delta
			
		#Changes direction if the guard touches a wall
		if is_on_wall():
			direction.x = direction.x * -1
			velocity.x = direction.x * SPEED
		
		#Changes icon direction when it hits a wall so character points in the right direction
		if direction.x == -1:
			$BearP1.flip_h = false
			$BearP2.flip_h = false
			$BearP3.flip_h = false
			$BearP4.flip_h = false
		elif direction.x == 1:
			$BearP1.flip_h = true
			$BearP2.flip_h = true
			$BearP3.flip_h = true
			$BearP4.flip_h = true
		#Animation
		var num = 1
		for i in range(4):
			#var node_path1 = "Bearp" + str(num)
			#var bear_sprite_visible = get_node(node_path1)
			$BearP1.modulate.a = 0
			get_tree().create_timer(0.3).timeout
			

		move_and_slide()

#Emits a signal when the player hits the side, connects to the player through the level scene
func _on_player_dies_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		player_died.emit()

#When the player jumps on the head of the enemy, the enemy dies.
func _on_head_jump_region_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
		player_killed_enemy.emit(position)

#If the level is paused or unpaused, it emits a signal.
#When the signal is recieved it's either true (paused) or false (unpaused)
#Makes the true or false variable the same as one that's already in game.
func pause(game_is_paused):
	is_paused = game_is_paused
