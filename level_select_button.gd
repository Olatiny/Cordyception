extends Button

@export var level_to_load: String

signal try_load_level(level_to_load)

func on_press():
	try_load_level.emit(level_to_load)
