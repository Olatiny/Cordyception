extends CharacterBody2D


## States the player can be in
enum STATE {
	IDLE,
	WALKING,
	CLIMBING,
	SEED_MODE,
	POSSESSING
}

## Current STATE
var my_state := STATE.IDLE




## Player's movement speed
@export var walk_speed := 75.0

## Player's gravity
@export var gravity := Vector2(0, 653.0)

## Total number of possessions the player can make
@export var num_possessions := 5


## Number of remaining possessions
var _remaining_possessions = num_possessions


## process the physucs
func _physics_process(delta: float) -> void:
	if not is_on_floor() && STATE.SEED_MODE == my_state:
		velocity += gravity * delta
	
	if (Input.is_action_just_pressed("jump")):
		velocity.y = -walk_speed * 4
	
	check_raycasts()
	
	update_animation()
	
	movement()
	
	move_and_slide()


## control bug
func possess():
	pass


## Handles movement according to player's state
func movement():
	
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


## Updates animations according to the player's state
func update_animation():
	match my_state:
		STATE.IDLE:
			pass
		_:
			pass



func check_raycasts():
	pass
