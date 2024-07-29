extends Node2D

var game_is_paused: bool = false
var level
signal pause(game_is_paused)

var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
var taco_scene: PackedScene = preload("res://scenes/items/taco.tscn")

var level_0_enemy_spawn_points = [Vector2(1750, 550), Vector2(2700, 550), Vector2(3300, 550)]

var level_1_enemy_spawn_points = [Vector2(791, 536), Vector2(3000, 500), Vector2(4088, 517)]

var level_2_enemy_spawn_points = [Vector2(1189, 540), Vector2(1964, 645), Vector2(3460, 548), Vector2(4111, 556), Vector2(2911, 448), Vector2(5041, 1029), Vector2(5269, 384)]


func _on_taco_collected():
	$UI/Stats.increase_score()
	
func _ready():
	var scene_name = str(get_tree().get_current_scene().get_name())
	level = int(scene_name[scene_name.length() - 1])
	

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not game_is_paused and not $Pedro.ended:
		game_is_paused = true
		pause.emit(game_is_paused)
		
	elif Input.is_action_just_pressed("pause") and game_is_paused:
		game_is_paused = false
		pause.emit(game_is_paused)
	


func _on_start_screen_started():
	var scene_name = str(get_tree().get_current_scene().get_name())
	var current_level = int(scene_name[scene_name.length() - 1])


	'''Tutorial level only'''
	if level == 0:
		if current_level != level:
			get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")

		'''Level 1 only'''
	elif level == 1:
		if current_level != level:
			get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

		'''Level 2 only'''
	elif level == 2:
		if current_level != level:
			get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
	

	'''Everything'''




	#Spawning Tacos
	for taco in $TacoSpawnPoints.get_children():
		spawn_taco(taco.position)
		
	#Spawning enemies
	for enemy in $EnemySpawnPoints.get_children():
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
	restart()
	$UI/Stats.ended = true

func remove_enemies():
	for enemy in $Enemies.get_children():
		$Enemies.remove_child(enemy)
		
func remove_tacos():
	for taco in $Items.get_children():
		$Items.remove_child(taco)
	

func restart():
	$UI/Start_Screen.SIGNAL = false
	#Enable buttons
	$UI/Start_Screen.disable_buttons(false)
			
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
