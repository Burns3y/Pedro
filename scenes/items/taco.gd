extends Area2D

var direction: Vector2 = Vector2.DOWN
var speed:int = 20
var initial_y: int
var current_direction: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_y = position.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	if (position.y > initial_y + 10) or (position.y < initial_y -10):
		current_direction *= -1
	
	if (position.y > initial_y + 9) or (position.y < initial_y -9):
		speed = 10
	else:
		speed = 20
	position += speed * direction * current_direction * delta




func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
