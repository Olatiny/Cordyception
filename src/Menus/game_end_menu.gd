extends Control
class_name GameEndMenu

@export var next_level_name: String
@onready var restart_button:= $"CenterContainer/VBoxContainer/Restart"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _restart():
	TommyGameManager.start_game()


func _main_menu():
	get_tree().change_scene_to_file("res://main_scene.tscn")
