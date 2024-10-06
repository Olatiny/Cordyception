class_name ControllableCreature
extends CharacterBody2D


## Player's movement speed
@export var walk_speed := 75.0

## Player's gravity
@export var gravity := 75.0

## Maximum x & y velocities
@export var terminal_velocity := Vector2(75, 75)

## Whether an object is being controlled
@export var controlled := false

## Number of times the secondary ability can be used
@export var num_secondary_uses := 3


## Maximum number of times secondary can be used
var _max_secondary_uses := num_secondary_uses


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handles all possible activities of a character while it is controlled
	if(controlled):
		check_move()
		check_jump()
		check_primary_action()
		check_secondary_action()
		update_animation()
		check_unpossess()
	
	velocity.x = clampf(velocity.x, -terminal_velocity.x, terminal_velocity.x)
	velocity.y = clampf(velocity.y, -terminal_velocity.y, terminal_velocity.y)
	
	move_and_slide()


func check_primary_action() -> void:
	pass


func check_secondary_action() -> void:
	pass


func check_move():
	pass


func check_jump():
	if (Input.is_action_just_pressed("jump")):
		velocity.y = -walk_speed * 4


func update_animation():
	pass

func check_unpossess():
	pass
