class_name ControlsIndicators
extends Control


@onready var possess_label := $BL/Label as Label
@onready var jump_label := $BR/Label as Label
@onready var primary_label := $Primary/Label as Label
@onready var secondary_label := $Secondary/Label as Label


func update_ui(bug: ControllableCreature):
	if bug is FunGuy:
		possess_label.text = "Possess"
		jump_label.text = "Jump"
		primary_label.text = "-"
		secondary_label.text = "-"
	elif bug is Grasshopper:
		possess_label.text = "Unpossess"
		jump_label.text = "Jump"
		primary_label.text = "High Jump"
		secondary_label.text = "Push"
	elif bug is PillBug:
		possess_label.text = "Unpossess"
		jump_label.text = "Jump" if bug.my_state == PillBug.STATE.BASE else "No Jump"
		primary_label.text = "Climb"
		secondary_label.text = "Ball" if bug.my_state != PillBug.STATE.BASE else "Unball"
	elif bug is WormCreature:
		possess_label.text = "Unpossess"
		jump_label.text = "No Jump"
		primary_label.text = "Destroy Dirt"
		secondary_label.text = "Burrow"
	
	$BR.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	$BL.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	$Primary.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	$Secondary.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
