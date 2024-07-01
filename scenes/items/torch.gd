extends Sprite2D

var fire_rgbs = [
Color(0.976, 0.863, 0.478), 
Color(0.839, 0.518, 0.18), 
Color(0.765, 0.596, 0.031), 
Color(0.953, 0.745, 0.043), 
Color(0.965, 0.796, 0.231), 
Color(0.973, 0.847, 0.424), 
Color(0.98, 0.898, 0.616)
]

var flicker_colour
var ended_flicker

func _ready():
	flicker_colour = fire_rgbs[randi() % fire_rgbs.size()]
	start_torch_flicker(flicker_colour)


func start_torch_flicker(flicker_colour):
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "color", flicker_colour, 1)
	$Timer.start()


func _process(_delta):
	if self == $"../Torch28":
		print($PointLight2D.color)


func _on_timer_timeout():
	print("Timer ended")
	flicker_colour = fire_rgbs[randi() % fire_rgbs.size()]
	start_torch_flicker(flicker_colour)
