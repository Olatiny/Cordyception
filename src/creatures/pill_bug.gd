class_name PillBug
extends PossessableCreature


enum STATE {BASE, PILL, SPIKE}

## current pillbug state
var my_state := BASE

## jump velocity for small jump
@export var small_jump_velocity := 50

## jump velocity for big jump
@export var ascend_velocity := 450


## area 2D for push secondary action
@onready var push_box := $PushBox as Area2D

## left facing collision shape for secondary action
@onready var push_left_shape := $PushBox/CollisionShapeLeft

## right facing action for secondary action
@onready var push_right_shape := $PushBox/CollisionShapeRight


var primary_used := false


## Updating valid push boxes
#func _physics_process(delta: float) -> void:
	#if face_direction == Vector2.LEFT:
		#push_left_shape.disabled = true
		#push_right_shape.disabled = false
	#elif face_direction == Vector2.RIGHT:
		#push_left_shape.disabled = false
		#push_right_shape.disabled = true
	#
	#super(delta)


## Grasshopper Big Jump
func check_primary_action() -> void:
	if not is_on_wall() || !Input.is_action_just_pressed("primary_ability"):
		return
	
	
	
	#velocity.y = -big_jump_velocity
	primary_used = true


## Grasshopper Push Block
func check_secondary_action() -> void:
	if !Input.is_action_just_pressed("secondary_ability"):
		return
	
	var block_components = push_box.get_overlapping_areas()
	
	for block in block_components:
		if block is Pushable:
			block.activate()


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


## TODO: animations
func update_animation():
	pass


## When grasshopper lands after using big jump, kil
func _on_land(body: Node2D) -> void:
	if primary_used && velocity.y >= 0:
		unpossess(true)
