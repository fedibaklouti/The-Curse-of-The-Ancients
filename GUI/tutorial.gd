extends Popup


onready var close = $Panel/VBoxContainer/close

func _input(event):
	if Input.is_action_just_pressed("player_jump"):
		visible=false


func _on_close_pressed():
	visible=false
	owner.NewGame.grab_focus()
	pass # Replace with function body.
