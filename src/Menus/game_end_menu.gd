extends Control
class_name GameEndMenu

@onready var resume_button = $"TextureRect/VBoxContainer/Resume"
@export var next_level_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _pause():
	visible = true
	resume_button.grab_focus()


func _next():
	visible = false
	get_tree().change_scene_to_file(next_level_name)


func _restart():
	pass


func _main_menu():
	get_tree().change_scene_to_file("res://src/Menus/main_menu.tscn")
