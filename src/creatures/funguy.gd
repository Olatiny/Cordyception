class_name FunGuy
extends ControllableCreature


## States the player can be in
enum STATE {
	IDLE,
	WALKING,
	CLIMBING,
	SPORE_MODE,
	POSSESSING,
	SPLAT
}

## Current STATE
var my_state := STATE.SPORE_MODE


## baby jump
@export var jump_velocity := 100.0

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
	if my_state == STATE.SPLAT:
		return
	
	update_state()
	
	if Input.is_action_just_pressed("possess"):
		possess()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	physics_collisions = possess_area.get_overlapping_bodies()
	
	super(delta)


## TODO: this comment
func update_state():
	if my_state == STATE.POSSESSING:
		return
	
	if grass_raycast_left.is_colliding() && grass_raycast_right.is_colliding():
		my_state = STATE.SPLAT
	else:
		my_state = STATE.IDLE
	

## Handles bug possession
func possess():
	var valid_bugs: Array[Node2D] = possess_area.get_overlapping_bodies()
	valid_bugs.erase(self)
	print("possess ",valid_bugs," ",valid_bugs.size())
	
	# no bugs to possess
	if valid_bugs.size() <= 0:
		return
	
	var closest_bug = valid_bugs.front()
	
	for bug in valid_bugs:
		if bug.position - position < closest_bug.position - position:
			closest_bug = bug
	
	print("closest bug ", closest_bug)
	if(closest_bug != null && closest_bug.try_possess()):
		queue_free()


## Updates animations according to the player's state
func update_animation():
	match my_state:
		STATE.IDLE:
			pass
		_:
			pass


## Handles movement according to player's state
func check_move():
	var direction := Input.get_axis("move_left", "move_right")
	
	if grass_raycast_left.is_colliding() && direction < 0 && my_state != STATE.SPORE_MODE:
		direction = 0
	
	if grass_raycast_right.is_colliding() && direction > 0 && my_state != STATE.SPORE_MODE:
		direction = 0
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


## Overridden to do NOTHING (player CANNOT jump)
func check_jump():
	if not is_on_floor() || !Input.is_action_just_pressed("jump"):
		return
	
	velocity.y = -jump_velocity


func kill():
	my_state = STATE.SPLAT
