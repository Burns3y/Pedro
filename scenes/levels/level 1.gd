extends Node2D

var game_is_paused: bool = false
signal pause(game_is_paused)

var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
var taco_scene: PackedScene = preload("res://scenes/items/taco.tscn")
var taco_spawn_points = [Vector2(875, 437), Vector2(1876, 286), Vector2(2726, 140), Vector2(4975, 221), Vector2(5675, 69)]
var enemy_spawn_points = [Vector2(791, 536), Vector2(3000, 500), Vector2(4088, 517)]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_taco_collected():
	$UI/Stats.increase_score()
	print("Collected")

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not game_is_paused:
		game_is_paused = true
		pause.emit(game_is_paused)
		
	elif Input.is_action_just_pressed("pause") and game_is_paused:
		game_is_paused = false
		pause.emit(game_is_paused)


func _on_start_screen_started():
	
	#Spawning Tacos
	for taco_position in taco_spawn_points:
		var new_taco = taco_scene.instantiate()
		$Items.add_child(new_taco)
		new_taco.position = taco_position
		#Connecting signal
		new_taco.connect("taco_collected", self._on_taco_collected)
		new_taco.name = "Taco"

	#Spawning enemies
	for enemy_position in enemy_spawn_points:
		var new_enemy = enemy_scene.instantiate() as CharacterBody2D
		new_enemy.position = enemy_position
		$Enemies.add_child(new_enemy)
		
		#Connecting signals
		new_enemy.connect("player_died", $Pedro._on_player_died)
		new_enemy.connect("player_died", $".". _on_player_died)
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
	$UI/Start_Screen/Panel/quit_button.disabled = false
	$UI/Start_Screen/Panel/start_button.disabled = false
	call_deferred("remove_enemies")
	call_deferred("remove_tacos")

