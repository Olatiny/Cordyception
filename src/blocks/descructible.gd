class_name Destructible
extends BlockComponent


const DESTROY_FX := preload("res://src/Particles/BlockBlowUpFX.tscn")


## Kill Block
func activate():
	var fx = DESTROY_FX.instantiate()
	fx.global_position = global_position
	get_tree().root.add_child(fx)
	block.queue_free()
