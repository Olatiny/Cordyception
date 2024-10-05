extends CharacterBody2D
class_name ControllableCreature

@export var creature_movement : BaseCreature
@export var base_node : Node

var controlled := false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if(controlled):
		var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"))
		fire_movement(direction)
		
		##check primary and secondary inputs

	move_and_slide()

func fire_primary_action() -> void:
	creature_movement.primary_action()

func fire_secondary_action() -> void:
	creature_movement.secondary_action()

func fire_movement(move_dir: Vector2) -> void:
	creature_movement.move(move_dir)

func get_movement() -> BaseCreature:
	return creature_movement
