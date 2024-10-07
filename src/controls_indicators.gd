class_name ControlsIndicators
extends Control

@export var active_color: Color
@export var inactive_color: Color

@onready var possess_label := $BL/Label as Label
@onready var possess_icon := $"BM/CenterContainer/R Icon" as TextureRect
@onready var jump_label := $BR/Label as Label
@onready var jump_icon := $"BR/CenterContainer/Space Icon" as TextureRect
@onready var primary_label := $Primary/Label as Label
@onready var primary_icon := $"Primary/CenterContainer/X Icon" as TextureRect
@onready var secondary_label := $Secondary/Label as Label
@onready var secondary_icon := $"Secondary/CenterContainer/C Icon" as TextureRect


func update_ui(bug: ControllableCreature):
	if bug is FunGuy:
		possess_label.text = "Possess"
		jump_label.text = "Jump"
		jump_label.modulate = active_color
		jump_icon.modulate = active_color
		primary_label.text = "-"
		primary_label.modulate = inactive_color
		primary_icon.modulate = inactive_color
		secondary_label.text = "-"
		secondary_label.modulate = inactive_color
		secondary_icon.modulate = inactive_color
	elif bug is Grasshopper:
		possess_label.text = "Unpossess"
		jump_label.text = "Jump"
		jump_label.modulate = active_color
		jump_icon.modulate = active_color
		primary_label.text = "High Jump"
		secondary_label.text = "Push"
		primary_label.modulate = active_color
		primary_icon.modulate = active_color
		secondary_label.modulate = active_color
		secondary_icon.modulate = active_color
	elif bug is PillBug:
		possess_label.text = "Unpossess"
		jump_label.text = "Jump" if bug.my_state == PillBug.STATE.BASE else "No Jump"
		jump_label.modulate = active_color if bug.my_state == PillBug.STATE.BASE else inactive_color
		jump_icon.modulate = active_color if bug.my_state == PillBug.STATE.BASE else inactive_color
		primary_label.text = "Climb"
		secondary_label.text = "Ball" if bug.my_state == PillBug.STATE.BASE else "Unball"
		primary_label.modulate = active_color
		primary_icon.modulate = active_color
		secondary_label.modulate = active_color
		secondary_icon.modulate = active_color
	elif bug is WormCreature:
		possess_label.text = "Unpossess"
		jump_label.text = "No Jump"
		jump_label.modulate = inactive_color
		jump_icon.modulate = inactive_color
		primary_label.text = "Destroy Dirt"
		secondary_label.text = "Burrow"
		primary_label.modulate = active_color
		primary_icon.modulate = active_color
		secondary_label.modulate = active_color
		secondary_icon.modulate = active_color
	
	$BR.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	$BL.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	$Primary.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	$Secondary.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
