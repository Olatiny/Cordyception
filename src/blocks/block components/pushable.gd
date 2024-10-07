class_name Pushable
extends BlockComponent


@export var push_speed := 100

var goal_pos: Vector2
var start_pos: Vector2
var dir: Vector2
var pushing := false


func _physics_process(delta: float) -> void:
	if pushing:
		var vel = dir * push_speed * delta
		
		if abs(block.global_position.x + vel.x - start_pos.x) > 8:
			vel = goal_pos - block.global_position
		
		block.move_and_collide(vel)
		
		pushing = !block.is_on_wall() && abs(block.global_position.x - start_pos.x) < 8


func activate():
	if block.is_on_wall() || pushing:
		return
	
	start_pos = block.global_position
	
	var bodies = get_overlapping_bodies()
	bodies.erase(block)
	
	if bodies.is_empty():
		return
	
	var enemy: ControllableCreature
	while !bodies.is_empty():
		enemy = bodies.pop_front()
		if enemy.controlled:
			break
	
	dir.x = -1 if block.global_position.x - enemy.global_position.x < 0 else 1
	dir.y = 0
	goal_pos = start_pos + dir * 8
	pushing = true
