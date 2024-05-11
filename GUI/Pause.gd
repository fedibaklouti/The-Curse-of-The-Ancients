extends PopupDialog

onready var ContinueButton = $VBoxContainer/continue
onready var RestartButton = $VBoxContainer/restart
onready var LeaderboardsButton = $VBoxContainer/leaderboards
onready var QuitButton = $VBoxContainer/Quit
onready var LevelManager = get_tree().get_root().get_node("Game")

func _ready():
	get_tree().paused = true
	popup()
	visible = true

func _on_continue_pressed():
	get_tree().paused = false
	call_deferred("queue_free")

func _on_restart_pressed():
	get_tree().paused = false
	LevelManager.restart_level()
	call_deferred("queue_free")


func _on_Quit_pressed():
	get_tree().paused = false
	GlobalStats.set_level_type(GlobalStats.Level_Type.NORMAL)
	get_tree().change_scene("res://Scenes/Mainmenu.tscn")
	MusicPlayer.stop()
	pass # Replace with function body.
