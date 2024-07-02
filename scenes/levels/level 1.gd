extends Node2D

var game_is_paused: bool = false
var level = 1
signal pause(game_is_paused)

var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
var taco_scene: PackedScene = preload("res://scenes/items/taco.tscn")

var tutorial_taco_spawn_points = [Vector2(1100, 475), Vector2(4675, 120)]
var tutorial_enemy_spawn_points = [Vector2(1750, 550), Vector2(2700, 550), Vector2(3300, 550)]

var level_1_taco_spawn_points = [Vector2(875, 437), Vector2(1876, 286), Vector2(2726, 140), Vector2(4975, 221), Vector2(5675, 69)]
var level_1_enemy_spawn_points = [Vector2(791, 536), Vector2(3000, 500), Vector2(4088, 517)]

var level_2_taco_spawn_points = [Vector2(220, 978), Vector2(670, 978), Vector2(1120, 978), Vector2(1570, 978), Vector2(2150, 776), Vector2(2550, 978), Vector2(3050, 978), Vector2(3600, 978), Vector2(4350, 915), Vector2(4725, 979), Vector2(5050, 875), Vector2(1027, 468), Vector2(1457, 468), Vector2(2125, 503), Vector2(2925, 268), Vector2(3475, 418), Vector2(4125, 418), Vector2(4800, 323), Vector2(5675, 69)]
var level_2_enemy_spawn_points = [Vector2(1189, 540), Vector2(1964, 645), Vector2(3460, 548), Vector2(4111, 556), Vector2(2911, 448), Vector2(5041, 1029), Vector2(5269, 384)]

#<600 >1200
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
	
	if $Pedro.ended:
		if level < 2:
			level += 1
		$Pedro.ended = false
	
	var taco_spawn_points
	var enemy_spawn_points
	
	if level == 0:
		taco_spawn_points = tutorial_taco_spawn_points
		enemy_spawn_points = tutorial_enemy_spawn_points
		$Tilemaps/TutorialMap.position.y = 0
		$Tilemaps/Lvl1Map.position.y = -1180
		$Tilemaps/Lvl2Map.position.y = 870
		
	elif level == 1:
		taco_spawn_points = level_1_taco_spawn_points
		enemy_spawn_points = level_1_enemy_spawn_points
		$Tilemaps/Lvl1Map.position.y = 0
		$Tilemaps/Lvl2Map.position.y = 870
		$Tilemaps/TutorialMap.position.y = -1180
		
	elif level == 2:
		taco_spawn_points = level_2_taco_spawn_points
		enemy_spawn_points = level_2_enemy_spawn_points
		$Tilemaps/TutorialMap.position.y = -1180
		$Tilemaps/Lvl1Map.position.y = -1180
		$Tilemaps/Lvl2Map.position.y = 0
		
		
		
	#Spawning Tacos
	for taco_position in taco_spawn_points:
		spawn_taco(taco_position)

	#Spawning enemies
	for enemy_position in enemy_spawn_points:
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
