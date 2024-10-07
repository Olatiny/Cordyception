class_name YouAreWinner
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is FunGuy:
		TommyGameManager.load_next_level()
