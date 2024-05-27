extends Node2D

var guard_1_spawned: bool = false
var guard_2_spawned: bool = false

var guard_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(_delta):
	if $Pedro.position.x > 1500 and not guard_2_spawned:
		var guard_2 = guard_scene.instantiate() as CharacterBody2D
		guard_2.position = Vector2(4088, 517)
		guard_2_spawned = true
		$Enemies.add_child(guard_2)
		$Enemies/Enemy.connect("player_died", $Pedro._on_player_died)
		$Enemies/Enemy.connect("player_died",$"Start_Screen"._on_player_died)


func _on_start_screen_started():
	if not guard_1_spawned:
		var guard_1 = guard_scene.instantiate() as CharacterBody2D
		guard_1.position = Vector2(791, 536)
		guard_1_spawned = true
		$Enemies.add_child(guard_1)
		$Enemies/Enemy.connect("player_died", $Pedro._on_player_died)
		$Enemies/Enemy.connect("player_died",$".". _on_player_died)
		
		
func _on_player_died():
	$Start_Screen.SIGNAL = false
	guard_1_spawned = false
	guard_2_spawned = false
