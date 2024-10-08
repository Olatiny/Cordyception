extends Area2D


## body enter
func _on_body_entered(body: Node2D) -> void:
	if body is PossessableCreature && body.controlled:
		body.unpossess(true, true)
	elif body is FunGuy:
		body.kill()
