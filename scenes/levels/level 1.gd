extends Node2D

var guard_1_spawned: bool = false
var guard_2_spawned: bool = false

var guard_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
var taco_scene: PackedScene = preload("res://scenes/items/taco.tscn")
var taco_spawn_points = [Vector2(875, 437), Vector2(1876, 286), Vector2(2726, 140), Vector2(5675, 69)]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_taco_collected():
	$UI/Stats.increase_score()
	print("Collected")

func _process(_delta):
	pass

func _on_start_screen_started():
	
	
	#Spawning Tacos
	for taco_position in taco_spawn_points:
		var new_taco = taco_scene.instantiate()
		$Items.add_child(new_taco)
		new_taco.position = taco_position
		new_taco.name = "Taco"
		#print(new_taco.position)
		
	for taco in $Items.get_children():
		taco.connect("taco_collected", self._on_taco_collected)
		##
	#var taco = taco_scene.instantiate()
	#$Items.add_child(taco)
	#taco.position = Vector2(390, 469)
	#taco.name = "Tester"
	#print(taco.position)
	#
	
	#Spawning guards
	if not guard_1_spawned:

		var guard_1 = guard_scene.instantiate() as CharacterBody2D
		guard_1.position = Vector2(791, 536)
		guard_1_spawned = true
		$Enemies.add_child(guard_1)
		guard_1.name = "Guard_1"

		guard_1.connect("player_died", $Pedro._on_player_died)
		guard_1.connect("player_died", $".". _on_player_died)

	if not guard_2_spawned:

		var guard_2 = guard_scene.instantiate() as CharacterBody2D
		guard_2.position = Vector2(4088, 517)
		guard_2_spawned = true
		$Enemies.add_child(guard_2)
		guard_2.name = "Guard_2"

		guard_2.connect("player_died", $Pedro._on_player_died)
		guard_2.connect("player_died", $"."._on_player_died)
		
	


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
	guard_1_spawned = false
	guard_2_spawned = false
	call_deferred("remove_enemies")
	call_deferred("remove_tacos")

