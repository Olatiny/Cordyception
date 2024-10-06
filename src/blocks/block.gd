class_name Block
extends CharacterBody2D


@export var gravity := -100.0
@export var is_diggable := false
@onready var collision := $"CollisionShape2D"

func disable():
	collision.disabled = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
