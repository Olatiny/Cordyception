class_name Blorticepts
extends Node2D


enum STATE {
	SHROOMNT = -1,
	SMOL = 2,
	MED = 1,
	BIG = 0
}

var my_state := STATE.SHROOMNT

@onready var areas: Array[Area2D] = [$SMOL as Area2D, $MED as Area2D, $BIG as Area2D]


func _physics_process(delta: float) -> void:
	var state_set = false
	
	var idx = 2
	for area in areas:
		if !state_set:
			state_set = set_state(idx, area.get_overlapping_bodies())
		else:
			set_state(idx, area.get_overlapping_bodies())
		
		idx -= 1
	
	if !state_set:
		my_state = STATE.SHROOMNT
	
	update_animation()


func set_state(idx: int, guys: Array[Node2D]) -> bool:
	if not guys.is_empty():
		for guy in guys:
			if guy is FunGuy:
				my_state = idx as STATE
				return true
	
	return false


func update_animation():
	if int(my_state) == -1:
		visible = false
		return
	
	visible = true
	$Sprite2D.frame = int(my_state)
