extends Node2D

var guard_1_spawned: bool = false
var guard_2_spawned: bool = false

var guard_scene: PackedScene = preload("res://scenes/enemies/border_patrol_guard.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if $Pedro.position.x > 1500 and guard_2_spawned != true:
		print("guard spawned")
		var guard_2 = guard_scene.instantiate() as CharacterBody2D
		guard_2.position = Vector2(4088, 517)
		guard_2_spawned = true
		$Enemies.add_child(guard_2)
		for i in range(5):
			print(guard_2.position)
