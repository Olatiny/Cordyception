class_name PillBug
extends PossessableCreature


enum STATE {
	BASE, 
	PILL, 
	SPIKE
}

var my_state := STATE.BASE

enum ANIMATION_STATE {
	IDLE,
	ROLL,
	WALKING,
	SPIKE_ROLL,
	JUMP
}

var ANIMATION_DICT = {
	ANIMATION_STATE.IDLE: "idle",
	ANIMATION_STATE.ROLL: "roll",
	ANIMATION_STATE.WALKING: "walk",
	ANIMATION_STATE.SPIKE_ROLL: "roll",
	ANIMATION_STATE.JUMP: "idle"
}

var my_animation_state := ANIMATION_STATE.IDLE

## jump velocity for small jump
@export var jump_velocity := 50

## jump velocity for big jump
@export var ascend_velocity := 450


## area 2D for push secondary action
@onready var wall_box := $WallBox as Area2D


var primary_used := false

var climb_shapes = []


## Updating valid push boxes
func _physics_process(delta: float) -> void:
	super(delta)
	
	if !alive:
		my_animation_state = ANIMATION_STATE.IDLE
		my_state = STATE.BASE
		$Sprite2D.rotation_degrees = 0
	
	update_state()
	
	if primary_used && alive:
		velocity.y = -ascend_velocity


func update_state():
	if my_animation_state == ANIMATION_STATE.JUMP && not is_on_floor():
		return
	
	if my_state == STATE.SPIKE:
		return
	
	if my_state == STATE.PILL:
		my_animation_state = ANIMATION_STATE.ROLL
	elif my_state == STATE.BASE:
		my_animation_state = ANIMATION_STATE.IDLE
	elif my_state == STATE.SPIKE:
		my_animation_state = ANIMATION_STATE.SPIKE_ROLL


## Grasshopper Big Jump
func check_primary_action() -> void:
	if !Input.is_action_just_pressed("primary_ability"):
		return
	
	climb_shapes = wall_box.get_overlapping_bodies()
	climb_shapes.erase(self)
	
	## Not against wall somehow
	if climb_shapes.is_empty():
		return
	
	$Sprite2D.rotation_degrees = 90 if $WallCheckL.get_collider() else -90
	
	my_state = STATE.SPIKE
	my_animation_state = ANIMATION_STATE.SPIKE_ROLL
	velocity.y = -ascend_velocity
	
	primary_used = true


## Grasshopper Push Block
func check_secondary_action() -> void:
	if my_state == STATE.SPIKE || !Input.is_action_just_pressed("secondary_ability"):
		return
	
	if my_state == STATE.BASE:
		my_state = STATE.PILL
	elif my_state == STATE.PILL:
		my_state = STATE.BASE


## Movement controls
func check_move():
	match my_state:
		STATE.BASE:
			_base_movement()
		STATE.PILL:
			_pill_movement()


## Normal (Non pill) Movement
func _base_movement():
	var direction := Input.get_axis("move_left", "move_right")
	
	my_animation_state = ANIMATION_STATE.WALKING
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


## PILL MOVEMENT (FUCK NON PILLS)
func _pill_movement():
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x += direction * walk_speed
	else:
		velocity.x += move_toward(velocity.x, 0, walk_speed)


## Checks for jump
func check_jump():
	if my_state == STATE.BASE && is_on_floor() && (Input.is_action_just_pressed("jump")):
		my_animation_state = ANIMATION_STATE.JUMP
		velocity.y = -jump_velocity


## TODO: animations
func update_animation(reset := false):
	var name = ANIMATION_DICT[my_animation_state]
	var suffix = "_L" if face_direction.x < 0 else "_R"
	name += suffix
	
	if reset || $AnimationPlayer.current_animation != name:
		$AnimationPlayer.play(name)


## WAL
func _on_wall_box_body_exited(body: Node2D) -> void:
	if !primary_used:
		return
	
	climb_shapes.erase(body)
	
	climb_shapes = wall_box.get_overlapping_bodies()
	climb_shapes.erase(self)
	
	if climb_shapes.is_empty():
		unpossess(true)
		primary_used = false


## aqowduibq
func unpossess(kill : bool, poison := false) -> void:
	if !alive || poison && kill && my_state != STATE.BASE:
		return
	
	controlled = false
	if (kill):
		alive = false
		$Sprite2D.modulate = Color(.2, .2, .2)
	
	var fun_dude := FUNGUY.instantiate() as FunGuy
	fun_dude.global_position = global_position
	fun_dude.velocity.y = -ascend_velocity if primary_used else -25.0
	get_tree().root.call_deferred("add_child", fun_dude)
