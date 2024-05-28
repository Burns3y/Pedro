extends CharacterBody2D

var SPEED = 13000
# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the TextEdit node (assuming it's a child of the current node)
	var text_edit = $TextEdit
	var NUM = 0
	# Set the text
	while true:
		text_edit.text = str(NUM)
		await get_tree().create_timer(1).timeout
		NUM += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	(move_and_slide())
