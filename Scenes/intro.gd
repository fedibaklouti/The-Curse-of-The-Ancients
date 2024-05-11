extends CanvasLayer


func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/levels/tilemaptest.tscn")
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("player_jump"):
		$AnimationPlayer.seek(27)
	if event is InputEventScreenTouch:
		if event.pressed:
			$AnimationPlayer.seek(27)
