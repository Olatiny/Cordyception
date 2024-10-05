extends ControllableCreature

var alive := true

func try_possess() -> bool:
	if(alive):
		controlled = true
		return true
		
	return false

func unpossess(kill : bool) -> void:
	controlled = false
	alive = !kill
