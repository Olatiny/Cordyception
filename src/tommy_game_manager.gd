extends Node2D


var LEVELS = [
	preload("res://src/levels/level_1.tscn"),
	preload("res://src/levels/level_2.tscn"),
	preload("res://src/levels/level_3.tscn"),
	preload("res://src/levels/level_4.tscn")
]

var current_level := 0

var in_menu := false

var current_player_entity: ControllableCreature

@onready var animation_player := $AnimationPlayer as AnimationPlayer

@onready var controls_indicators := $CanvasLayer/ControlsIndicators as ControlsIndicators


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset") && animation_player.current_animation != "reset_level":
		animation_player.play("reset_level")


func start_game():
	current_level = -1
	animation_player.play("progress_level")


func load_next_level():
	if animation_player.current_animation != "progress_level":
		animation_player.play("progress_level")


func progress_level():
	if current_level >= LEVELS.size():
		pass #TODO: win game screen
	
	current_level += 1
	
	get_tree().change_scene_to_packed(LEVELS[current_level])


func reset_level(from_code := false):
	if from_code:
		animation_player.play("reset_level")
	else:
		get_tree().reload_current_scene()
