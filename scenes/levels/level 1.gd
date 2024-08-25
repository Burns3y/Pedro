extends Node2D

#Preparing variables that should be known throughout the script - pause and level checkers
var game_is_paused: bool = false
var level
var current_level

#Emits when the game is paused
signal pause(game_is_paused)

#Preloading enemies and tacos
var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
var taco_scene: PackedScene = preload("res://scenes/items/taco.tscn")

#When taco is collected, increases score
func _on_taco_collected():
	$UI/Stats.increase_score()

#Run when the scene is first loaded
func _ready():
	#Finds the name of the current level to check what the level is
	var scene_name = str(get_tree().get_current_scene().get_name())
	level = int(scene_name[scene_name.length() - 1])
	
#Run every frame of the game
func _process(_delta):
	#Loops the music
	if $AudioStreamPlayer_music.playing == false && not $Pedro.ended:
		$AudioStreamPlayer_music.play()

	#Pauses the game
	if Input.is_action_just_pressed("pause") and not game_is_paused and not $Pedro.ended:
		game_is_paused = true
		pause.emit(game_is_paused)
	
	#Unpauses the game
	elif Input.is_action_just_pressed("pause") and game_is_paused:
		game_is_paused = false
		pause.emit(game_is_paused)
	

#When the start button is pressed
func _on_start_screen_started():
	#Gets the current scene by checking the name again
	var scene_name = str(get_tree().get_current_scene().get_name())
	current_level = int(scene_name[scene_name.length() - 1])


	#Changes the level unless it's already that level
	if level == 0:
		if current_level != level:
			get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")

	elif level == 1:
		if current_level != level:
			get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

	elif level == 2:
		if current_level != level:
			get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
	

	#Spawning Tacos
	for taco in $TacoSpawnPoints.get_children():
		spawn_taco(taco.position)
		
	#Spawning enemies
	for enemy in $EnemySpawnPoints.get_children():
		#Instantiating
		var new_enemy = enemy_scene.instantiate() as CharacterBody2D
		new_enemy.position = enemy.position
		$Enemies.add_child(new_enemy)
		
		#Connecting signals
		new_enemy.connect("player_died", $Pedro._on_player_died)
		new_enemy.connect("player_died", self._on_player_died)
		new_enemy.connect("player_killed_enemy", self.player_killed_enemy)
		self.connect("pause", new_enemy.pause)
		new_enemy.name = "Enemy"


func _on_player_died():
	#Restarts the game
	restart()
	$UI/Stats.ended = true

func remove_enemies():
	#Goes through the enemies node and removes all of them
	for enemy in $Enemies.get_children():
		$Enemies.remove_child(enemy)

func remove_tacos():
	#Goes through the tacos node and removes all of them
	for taco in $Items.get_children():
		$Items.remove_child(taco)

#Resets the game
func restart():
	$UI/Start_Screen.SIGNAL = false
	#Enable buttons
	$UI/Start_Screen.disable_buttons(false)
	#Removes the tacos and enemies when possible
	call_deferred("remove_enemies")
	call_deferred("remove_tacos")

#If the enemy died
func player_killed_enemy(enemy_position):
	#Spawns a taco when the enemy dies
	spawn_taco(enemy_position)

#Spawns tacos when scene starts or enemy dies
func spawn_taco(taco_position):
	#Instantiating
	var new_taco = taco_scene.instantiate()
	new_taco.position = taco_position
	$Items.call_deferred("add_child", new_taco)
	
	#Connecting signal
	new_taco.connect("taco_collected", self._on_taco_collected)
	new_taco.name = "Taco"
