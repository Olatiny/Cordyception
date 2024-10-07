extends Control
class_name MainMenu

@onready var main_menu_screen := $"MainScreen"
@onready var level_select_screen := $"LevelSelectScreen"
@onready var start_button := $"MainScreen/MainMenuOptions/Start"
@onready var level_one_button := $"LevelSelectScreen/Levels/Level 1"
@onready var level_button_holder := $"LevelSelectScreen/Levels"

@export var level_one_name := "res://wormtest2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OpenMainMenu()
	for level_button in level_button_holder.get_children():
		level_button.try_load_level.connect(LoadLevel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func StartGame():
	LoadLevel(level_one_name)
	
func LoadLevel(level: String):
	print("load level ", level)
	#load(level)
	get_tree().change_scene_to_file(level)

func OpenMainMenu():
	main_menu_screen.visible = true
	level_select_screen.visible = false
	start_button.grab_focus()

func OpenLevelSelect():
	main_menu_screen.visible = false
	level_select_screen.visible = true
	level_one_button.grab_focus()

func Quit():
	get_tree().quit()
