extends Node
class_name BaseCreature

var character_body : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func primary_action() -> void:
	pass

func secondary_action() -> void:
	pass

func move(input: Vector2) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_body(body: CharacterBody2D):
	character_body = body

func jump(jump_vector: Vector2) -> void:
	if character_body.is_on_floor():
		character_body.velocity.y = jump_vector.y
		character_body.velocity.x = jump_vector.x
