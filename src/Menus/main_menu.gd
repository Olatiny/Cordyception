extends Control
class_name MainMenu

@onready var main_menu_screen := $"MainScreen"
@onready var credits_screen := $"CreditsScreen"
@onready var start_button := $"MainScreen/MainMenuOptions/Start"

@export var level_one_name := "res://wormtest2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OpenMainMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func StartGame():
	TommyGameManager.start_game()


func LoadLevel(level: String):
	print("load level ", level)
	#load(level)
	get_tree().change_scene_to_file(level)


func OpenMainMenu():
	start_button.grab_focus()
	main_menu_screen.visible = true
	credits_screen.visible = false


func OpenCredits():
	start_button.release_focus()
	main_menu_screen.visible = false
	credits_screen.visible = true


func Quit():
	get_tree().quit()
