class_name GameCamera
extends Camera2D


@export var bounds := Vector2(10, 45)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dude = TommyGameManager.current_player_entity
	
	if !is_instance_valid(dude):
		return
	
	var dist = dude.position.x - get_screen_center_position().x
	
	if abs(dist) > bounds.x:
		position.x = move_toward(position.x, position.x + dist, delta * 25)
		position.x = clampf(position.x, limit_left + 160, limit_right - 160)
