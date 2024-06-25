extends Sprite2D

#var fire_rgbs = [Color(0.976, 0.863, 0.478), Color(0.839, 0.518, 0.18), Color(0.765, 0.596, 0.031), Color(0.953, 0.745, 0.043), Color(0.965, 0.796, 0.231), Color(0.973, 0.847, 0.424), Color(0.98, 0.898, 0.616)]
#var new_flicker_colour
## Called when the node enters the scene tree for the first time.
#func _ready():
	#var initial_colour = fire_rgbs[randi() % fire_rgbs.size()]
	#while true:
		#new_flicker_colour = fire_rgbs[randi() % fire_rgbs.size()]
		##$PointLight2D.color = flicker_colour
		#var tween = get_tree().create_tween()
		#tween.interpolate_value(initial_colour, new_flicker_colour,0 , 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#initial_colour = new_flicker_colour
		#await get_tree().create_timer((randi() % 5) * 0.05).timeout
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
