class_name FunGuy
extends ControllableCreature


const POSSESS_SOUND = preload("res://assets/Audio/possess.wav")


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


## left rock detector raycast
@onready var rock_raycast_left := $RockDetectorLeft as RayCast2D

## right rock detector raycast
@onready var rock_raycast_right := $RockDetectorRight as RayCast2D

## left ground detector raycast
@onready var ground_raycast_left := $GroundDetectorLeft as RayCast2D

## right ground detector raycast
@onready var ground_raycast_right := $GroundDetectorRight as RayCast2D

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
	
	physics_collisions = possess_area.get_overlapping_bodies()
	
	super(delta)


## TODO: this comment
func update_state():
	if my_state == STATE.POSSESSING:
		return
	
	if is_on_floor():
		if rock_raycast_left.is_colliding() && (rock_raycast_right.is_colliding() || !ground_raycast_left.is_colliding()):
			kill()
		elif rock_raycast_right.is_colliding() && (rock_raycast_left.is_colliding() || !ground_raycast_right.is_colliding()):
			kill()
	else:
		my_state = STATE.IDLE
	

## Handles bug possession
func possess():
	var valid_bugs: Array[Node2D] = possess_area.get_overlapping_bodies()
	valid_bugs.erase(self)
	print("possess ",valid_bugs," ",valid_bugs.size())
	
	AudioManager.play_sfx(POSSESS_SOUND)
	
	# no bugs to possess
	if valid_bugs.size() <= 0:
		return
	
	var closest_bug = valid_bugs.front()
	
	for bug in valid_bugs:
		if !closest_bug.alive:
			closest_bug = bug
			continue
		 
		if bug.position - position < closest_bug.position - position && bug.alive:
			closest_bug = bug
	
	print("closest bug ", closest_bug)
	if(closest_bug != null && closest_bug.try_possess()):
		queue_free()


## Updates animations according to the player's state
func update_animation():
	if velocity.y == 0:
		$AnimationPlayer.play("idle")
	elif velocity.y > 0:
		$AnimationPlayer.play("up")
	else:
		$AnimationPlayer.play("down")


## Handles movement according to player's state
func check_move():
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		$Sprite2D.flip_h = true
	elif direction < 0:
		$Sprite2D.flip_h = false
	
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)


## Overridden to do NOTHING (player CANNOT jump)
func check_jump():
	if not is_on_floor() || !Input.is_action_just_pressed("jump"):
		return
	
	AudioManager.play_sfx(JUMP_SOUND, 0.02)
	
	velocity.y = -jump_velocity


func kill():
	my_state = STATE.SPLAT
	modulate = Color(.2, .2, .2)
	scale.y /= 2
	
	AudioManager.play_sfx(KILL_SOUND)
	
	await get_tree().create_timer(1).timeout

	TommyGameManager.reset_level(true)
