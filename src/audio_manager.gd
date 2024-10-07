extends Node2D


@onready var music := $Music as AudioStreamPlayer


## Toggles paused state
func set_pause(state: bool):
	music.stream_paused = state


## Stops audio players
func stop():
	music.stop()


## Restarts audio players
func restart():
	music.stop()
	music.play()


## Plays a sound effect and destroys itself upon completion
func play_sfx(sfx_stream: AudioStream, pitch_variation := 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sfx_stream
	player.finished.connect(Callable(player, "queue_free"))
	
	if (pitch_variation > 0):
		player.pitch_scale = randf_range(2**-abs(pitch_variation), 2**abs(pitch_variation))
	
	get_tree().root.add_child(player)
	player.play()
