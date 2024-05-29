extends Node2D

var guard_1_spawned: bool = false
var guard_2_spawned: bool = false

var guard_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pass

func _on_start_screen_started():
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
	$UI/Start_Screen.SIGNAL = false
	guard_1_spawned = false
	guard_2_spawned = false
	call_deferred("remove_enemies")

func remove_enemies():
	for enemy in $Enemies.get_children():
		$Enemies.remove_child(enemy)
