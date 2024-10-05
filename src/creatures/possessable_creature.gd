class_name PossessableCreature
extends ControllableCreature

var alive := true

const FUNGUY := preload("res://src/creatures/funguy.tscn")

func try_possess() -> bool:
	if(alive):
		controlled = true
		return true
		
	return false

func unpossess(kill : bool) -> void:
	controlled = false
	alive = !kill
	
	var fun_dude := FUNGUY.instantiate() as FunGuy
	fun_dude.global_position = global_position
	fun_dude.velocity.y = -25.0
	get_tree().root.add_child(fun_dude)

## Handles movement according to player's state
func check_move():
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

func check_unpossess():
	if(Input.is_action_just_pressed("possess")):
		unpossess(false)
