extends Control

onready var NewGame = $"Container/VBoxContainer/NG"
onready var Tutorial = $Container/VBoxContainer/Tutorial
onready var Quit = $"Container/VBoxContainer/Quit"

onready var Animator = $AnimationPlayer

var SelectedIndex = 0
onready var ButtonsArray = [NewGame, Tutorial, Quit]

func _ready():
	NewGame.grab_focus()
	pass
	
	

func _input(event):
	if Input.is_action_just_pressed("player_jump"):
		if Animator.get_current_animation()=="fadein":
			Animator.seek(5)
			ButtonsArray[0].grab_focus()
	if Input.is_action_just_pressed("player_down"):
		SelectedIndex = wrapi(SelectedIndex + 1, 0, len(ButtonsArray))
		ButtonsArray[SelectedIndex].grab_focus()
	if Input.is_action_just_pressed("player_up"):
		SelectedIndex = wrapi(SelectedIndex - 1, 0, len(ButtonsArray))
		ButtonsArray[SelectedIndex].grab_focus()
		

func _on_NG_pressed():
	Animator.play("fadeout")
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	pass 


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fadeout":
			yield(get_tree().create_timer(0.5),"timeout")
			get_tree().change_scene("res://Scenes/intro.tscn")
		"fadein":
			NewGame.grab_focus()
	pass 


func _on_Quit_pressed():
	get_tree().quit()
	pass 


func _on_Tutorial_pressed():
	$tutorial.visible=true
	$tutorial.close.grab_focus()
	pass # Replace with function body.
