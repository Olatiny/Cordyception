class_name PossessableCreature
extends ControllableCreature

var alive := true

const FUNGUY := preload("res://src/creatures/funguy.tscn")

var just_possessed := false


func _physics_process(delta: float) -> void:
	super(delta)
	
	if !alive || !controlled:
		velocity.x = move_toward(velocity.x, 0, 100 * delta)
	
	$Possess.visible = controlled || !alive
	
	if just_possessed:
		just_possessed = false



func try_possess() -> bool:
	if(alive):
		controlled = true
		just_possessed = true
		return true
		
	return false


func unpossess(kill : bool, poison := false) -> void:
	controlled = false
	if(kill):
		AudioManager.play_sfx(KILL_SOUND)
		alive = false
		modulate = Color(.2, .2, .2)
		scale.y = -1
	
	var fun_dude := FUNGUY.instantiate() as FunGuy
	fun_dude.global_position = global_position + Vector2(0, -4)
	fun_dude.velocity.y = -fun_dude.jump_velocity
	get_parent().call_deferred("add_child", fun_dude)


## Handles movement according to player's state
func check_move():
	if(!alive):
		return
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


func check_unpossess():
	if !just_possessed && Input.is_action_just_pressed("possess"):
		unpossess(false)
