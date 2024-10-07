class_name Grasshopper
extends PossessableCreature


enum STATE {
	IDLE,
	PUSH,
	WALK,
	JUMP
}

@export var my_state := STATE.IDLE

const ANIM_DICT = {
	STATE.IDLE: "idle",
	STATE.WALK: "walk",
	STATE.PUSH: "push",
	STATE.JUMP: "idle"
}


## jump velocity for small jump
@export var small_jump_velocity := 50

## jump velocity for big jump
@export var big_jump_velocity := 1000


## area 2D for push secondary action
@onready var push_box := $PushBox as Area2D

## left facing collision shape for secondary action
@onready var push_left_shape := $PushBox/CollisionShapeLeft

## right facing action for secondary action
@onready var push_right_shape := $PushBox/CollisionShapeRight


var primary_used := false

var unpossessed_post_kill := false


## Updating valid push boxes
func _physics_process(delta: float) -> void:
	if face_direction == Vector2.LEFT:
		push_left_shape.disabled = true
		push_right_shape.disabled = false
	elif face_direction == Vector2.RIGHT:
		push_left_shape.disabled = false
		push_right_shape.disabled = true
	
	set_state()
	
	super(delta)


func set_state():
	if my_state == STATE.PUSH:
		return
	
	if my_state == STATE.JUMP && not is_on_floor():
		return
	
	if velocity != Vector2.ZERO:
		my_state = STATE.WALK
	else:
		my_state = STATE.IDLE


## Grasshopper Big Jump
func check_primary_action() -> void:
	if not is_on_floor() || !Input.is_action_just_pressed("primary_ability"):
		return
	
	velocity.y = -big_jump_velocity
	primary_used = true


## Grasshopper Push Block
func check_secondary_action() -> void:
	if !Input.is_action_just_pressed("secondary_ability"):
		return
	
	var block_components = push_box.get_overlapping_areas()
	
	for block in block_components:
		if block is Pushable:
			block.activate()
			my_state = STATE.PUSH
			update_animation(true)


## Movement controls
func check_move():
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


## Checks for jump
func check_jump():
	if is_on_floor() && (Input.is_action_just_pressed("jump")):
		velocity.y = -small_jump_velocity
		my_state = STATE.JUMP


## When grasshopper lands after using big jump, kil
func _on_land(body: Node2D) -> void:
	if !unpossessed_post_kill && primary_used && velocity.y >= 0:
		unpossess(true)


func unpossess(kill : bool, poison := false) -> void:	
	controlled = false
	if(kill || primary_used):
		alive = false
		unpossessed_post_kill = true
		modulate = Color(.2, .2, .2)
		scale.y = -1
	
	var fun_dude := FUNGUY.instantiate() as FunGuy
	fun_dude.global_position = global_position + Vector2(0, -4)
	fun_dude.velocity.y = -fun_dude.jump_velocity
	get_parent().call_deferred("add_child", fun_dude)


func update_animation(restart := false):
	var name = ANIM_DICT[my_state]
	var suffix = "_L" if face_direction.x < 0 else "_R"
	name += suffix
	
	if restart || $AnimationPlayer.current_animation != name:
		$AnimationPlayer.play(name)
