extends Camera2D


@export var scroll_speed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position.x += scroll_speed * delta
