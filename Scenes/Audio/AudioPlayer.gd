extends AudioStreamPlayer2D


func _play(audiopath,volume,position):
	global_position=position
	stream=load(audiopath)
	volume_db=volume
	play()


func _on_AudioStreamPlayer2D_finished():
	call_deferred("queue_free")
	pass # Replace with function body.

func _process(delta):
	position.x-=6+GlobalStats.offset
