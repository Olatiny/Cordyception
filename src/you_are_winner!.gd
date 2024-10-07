class_name YouAreWinner
extends Area2D

const WIN_SOUND = preload("res://assets/Audio/clear_level.wav")


func _on_body_entered(body: Node2D) -> void:
	if body is FunGuy:
		TommyGameManager.load_next_level()
		AudioManager.play_sfx(WIN_SOUND)
