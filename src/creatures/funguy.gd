class_name FunGuy
extends CharacterBody2D


## States the player can be in
enum STATE {
	IDLE,
	WALKING,
	CLIMBING,
	SPORE_MODE,
	POSSESSING
}

## Current STATE
var my_state := STATE.SPORE_MODE


## Player's movement speed
@export var walk_speed := 75.0

## Player's gravity
@export var gravity := 75.0

## Maximum x & y velocities
@export var terminal_velocity := Vector2(75, 75)

## Total number of possessions the player can make
@export var num_possessions := 5


## left grass detector raycast
@onready var grass_raycast_left := $GrassDetectorLeft as RayCast2D

## right grass detector raycast
@onready var grass_raycast_right := $GrassDetectorRight as RayCast2D

## area 2d used for possession
@onready var possess_area := $PossessArea as Area2D

## collission shape used for possession
@onready var possess_shape := $PossessArea/PossessShape as CollisionShape2D


## Number of remaining possessions
var _remaining_possessions = num_possessions


## process the physucs
func _physics_process(delta: float) -> void:
	update_state()
	
	if not is_on_floor() && STATE.SPORE_MODE == my_state:
		velocity = Vector2(velocity.x, clampf(velocity.y + gravity * delta, 0, terminal_velocity.y))
	
	# debug jump lol
	#if (Input.is_action_just_pressed("jump")):
		#velocity.y = -walk_speed * 4
	
	if Input.is_action_just_pressed("possess"):
		possess()
	
	movement()
	
	update_animation()
	
	move_and_slide()


##
func update_state():
	if my_state == STATE.POSSESSING:
		return
	
	if !grass_raycast_left.is_colliding() && !grass_raycast_right.is_colliding():
		my_state = STATE.SPORE_MODE
	else:
		my_state = STATE.IDLE


## Handles bug possession
func possess():
	possess_shape.disabled = false
	
	var valid_bugs: Array[Node2D] = possess_area.get_overlapping_bodies()
	valid_bugs.erase(self)
	
	# no bugs to possess
	if valid_bugs.size() <= 0:
		possess_shape.disabled
		return
	
	var closest_bug = valid_bugs.front()
	
	for bug in valid_bugs:
		if bug.position - position < closest_bug.position - position:
			closest_bug = bug
	
	# TODO: possess closest_bug
	
	possess_shape.disabled = true


## Updates animations according to the player's state
func update_animation():
	match my_state:
		STATE.IDLE:
			pass
		_:
			pass


## Handles movement according to player's state
func movement():
	var direction := Input.get_axis("move_left", "move_right")
	
	if !grass_raycast_left.is_colliding() && direction < 0:
		direction = 0
	
	if !grass_raycast_right.is_colliding() && direction > 0:
		direction = 0
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed / 4)
