extends Node


var debugbuild = true





var shadowsenabled = true
var shadowsfilter = 0
var shadowsqualityres = 4096

var highshadows=4096
var mediumshadows=2048
var lowshadows= 1024




#var sceneloader = load("res://scenes/debug_sceneloader.tscn")


func _ready():
	pause_mode=Node.PAUSE_MODE_PROCESS
	debugbuild=OS.is_debug_build()



func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen	



func wrap_index(index, length):
	return ((index % length) + length) % length
