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

# Called when the node enters the scene tree for the first time.
func _ready():
	var flicker_colour = fire_rgbs[randi() % fire_rgbs.size()]
	start_torch_flicker(flicker_colour)


func start_torch_flicker(flicker_colour):
	var random_time = randi() % 20 + 1
	random_time = float(random_time)
	var tween = get_tree().create_tween()
	var energy_changing = -0.5
	
	#Animations, changing energy and colour at the same time
	
	#$AnimationPlayer.play("Flicker")
	#self.frame = 0
	tween.tween_property($PointLight2D, "color", flicker_colour, random_time / 5)
	#tween.parallel()
	#tween.tween_property($PointLight2D, "energy", $PointLight2D.energy + energy_changing, random_time)
	
	
	
	#Setting up timer
	$Timer.wait_time = random_time / 5
	$Timer.start()


func _on_timer_timeout():
	var flicker_colour = fire_rgbs[randi() % fire_rgbs.size()]
	start_torch_flicker(flicker_colour)
	if randi() % 3 == 1:
		$CPUParticles2D.emitting = true

