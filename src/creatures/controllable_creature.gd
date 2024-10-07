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

var physics_collisions : Array
## Number of times the secondary ability can be used
@export var num_secondary_uses := 3

## The current direction we are facing
var face_direction := Vector2.RIGHT

## Max was hee
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
		check_unpossess()
		TommyGameManager.controls_indicators.update_ui(self)
		
		if TommyGameManager.current_player_entity != self:
			TommyGameManager.current_player_entity = self
	
	update_animation()
	
	velocity.x = clampf(velocity.x, -terminal_velocity.x, terminal_velocity.x)
	velocity.y = clampf(velocity.y, -terminal_velocity.y, terminal_velocity.y)
	
	if velocity.x < 0:
		face_direction = Vector2.LEFT
	elif velocity.x > 0:
		face_direction = Vector2.RIGHT
	
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
