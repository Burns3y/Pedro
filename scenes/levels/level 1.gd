extends Node2D

var game_is_paused: bool = false
var current_level: int = 1
signal pause(game_is_paused)

var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
var taco_scene: PackedScene = preload("res://scenes/items/taco.tscn")

var tutorial_taco_spawn_points = [Vector2(1100, 475), Vector2(4675, 120)]
var tutorial_enemy_spawn_points = [Vector2(1750, 550), Vector2(2700, 550), Vector2(3300, 550)]

var level_1_taco_spawn_points = [Vector2(875, 437), Vector2(1876, 286), Vector2(2726, 140), Vector2(4975, 221), Vector2(5675, 69)]
var level_1_enemy_spawn_points = [Vector2(791, 536), Vector2(3000, 500), Vector2(4088, 517)]

var level_2_taco_spawn_points = []
var level_2_enemy_spawn_points = []

var taco_spawn_points = [Vector2(1, 1)]
var enemy_spawn_points = [Vector2(1, 1)]


func _on_taco_collected():
	$UI/Stats.increase_score()

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not game_is_paused and not $Pedro.ended:
		game_is_paused = true
		pause.emit(game_is_paused)
		
	elif Input.is_action_just_pressed("pause") and game_is_paused:
		game_is_paused = false
		pause.emit(game_is_paused)


func _on_start_screen_started():

	'''Tutorial level only'''
	if current_level == 0:
		get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")
		taco_spawn_points = tutorial_taco_spawn_points
		enemy_spawn_points = tutorial_enemy_spawn_points


		'''Level 1 only'''
	elif current_level == 1:
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
		taco_spawn_points = level_1_taco_spawn_points
		enemy_spawn_points = level_1_enemy_spawn_points
	
	
	
		'''Level 2 only'''
	elif current_level == 2:
		#for child in $Level2EnemySpawnPoints.get_children():
			#if child.position not in level_2_enemy_spawn_points:
				#level_2_enemy_spawn_points.append(child.position)
		get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
		taco_spawn_points = level_2_taco_spawn_points
		enemy_spawn_points = level_2_enemy_spawn_points
	
	
	'''Everything'''
	
	
	#Changes level up
	if $Pedro.ended:
		if current_level < 2:
			current_level += 1
		$Pedro.ended = false


	#Spawning Tacos
	for taco_position in taco_spawn_points:
		spawn_taco(taco_position)

	#Spawning enemies
	for enemy_position in enemy_spawn_points:
		#Creates a variable called new_enemy
		var new_enemy = enemy_scene.instantiate() as CharacterBody2D
		new_enemy.position = enemy_position
		$Enemies.add_child(new_enemy)
		
		#Connecting signals
		new_enemy.connect("player_died", $Pedro._on_player_died)
		new_enemy.connect("player_died", self._on_player_died)
		new_enemy.connect("player_killed_enemy", self.player_killed_enemy)
		self.connect("pause", new_enemy.pause)
		new_enemy.name = "Enemy"


func _on_player_died():
	restart()
	$UI/Stats.ended = true

func remove_enemies():
	for enemy in $Enemies.get_children():
		$Enemies.remove_child(enemy)
		
func remove_tacos():
	for taco in $Items.get_children():
		$Items.remove_child(taco)


func restart():
	print("restarted")
	$UI/Start_Screen.SIGNAL = false
	#Enable buttons
	for i in $UI/Start_Screen/Panel.get_children():
		if i is Button:
			i.disabled = false

	call_deferred("remove_enemies")
	call_deferred("remove_tacos")

func player_killed_enemy(enemy_position):
	#Spawns a taco when the enemy dies
	spawn_taco(enemy_position)


func spawn_taco(taco_position):
	var new_taco = taco_scene.instantiate()
	new_taco.position = taco_position
	$Items.call_deferred("add_child", new_taco)
	#Connecting signal
	new_taco.connect("taco_collected", self._on_taco_collected)
	new_taco.name = "Taco"


func create_spawn_points():
	pass
