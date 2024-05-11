extends Node2D


#LEVELS TO SPAWN
var level_list= []

var level_backgrounds = ["res://Scenes/levels/normalbackground.tscn",
"res://Scenes/levels/hellbackground.tscn", "res://Scenes/levels/heavenbackground.tscn"
	
]

var normal_level_list= GlobalStats.normal_level_list

var hell_level_list= GlobalStats.hell_level_list

var heaven_level_list= GlobalStats.heaven_level_list

var LevelColors=[Color(200,200,200),Color(200,15,15),Color(225,200,150)]

enum Level_Type {NORMAL, HELL, HEAVEN}

var BGM_Levels = [preload("res://Audio/BGM/BGM_NORMAL.ogg"), 
preload("res://Audio/BGM/BGM_HELL.ogg"), preload("res://Audio/BGM/BGM_HEAVEN.ogg")  ]


var PreviousLevelInstance
onready var CurrentLevel = preload("res://Scenes/levels/TestTileMap.tscn")
onready var NextLevel = preload("res://Scenes/levels/TestTileMap2.tscn")
var CurrentLevelInstance
var NextLevelInstance
var currentpath = "res://Scenes/levels/TestTileMap.tscn"

onready var player = $player
onready var HUD = $"userinterface/hud" 

func remove_all_children(node):
	for i in node.get_children():
		node.remove_child(i)
		i.queue_free()


func restart_level():
	if GlobalStats.level_type != GlobalStats.Level_Type.HEAVEN:
		get_tree().reload_current_scene()
		GlobalStats.PlayerScore=0
	pass


func _input(event):
	if (GlobalStats.PlayerStatus == 3) && ((Input.is_action_just_pressed("player_retry")) || (event is InputEventScreenTouch && event.pressed)) :
#dead
		if GlobalStats.level_type != GlobalStats.Level_Type.HEAVEN:
			get_tree().reload_current_scene()
			GlobalStats.PlayerScore=0
			


var offset=0
var tween
func _ready():
	HUD.changeRunes()
	Fader.fadeout()
	if MusicPlayer.get_stream() != BGM_Levels[GlobalStats.level_type]:
		MusicPlayer.stream= BGM_Levels[GlobalStats.level_type]
		MusicPlayer.play()
	randomize()
	var background_obj=load(level_backgrounds[GlobalStats.level_type]).instance()
	call_deferred("add_child", background_obj)
	match GlobalStats.level_type:
		Level_Type.NORMAL:
			level_list=normal_level_list
			call_deferred("remove_all_children", $hellnode)
		Level_Type.HELL:
			level_list=hell_level_list
			$mummy.call_deferred("queue_free")
		Level_Type.HEAVEN:
			level_list=heaven_level_list
			$mummy.call_deferred("queue_free")
			call_deferred("remove_all_children", $hellnode)
	CurrentLevel=level_list[0].instance
	NextLevel=level_list[1].instance
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "offset",0,5,100,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
	tween.start()
	get_node_or_null("player").connect("scorechanged",HUD, "changescore")
	get_node_or_null("player").connect("ammochanged",HUD,"update_ammo")
	get_node_or_null("player").connect("specialscore",HUD, "specialscore")
	
	get_node_or_null("player").connect("died",HUD, "death_ui")

	CurrentLevelInstance = CurrentLevel.instance()
	call_deferred("add_child", CurrentLevelInstance)
	PreviousLevelInstance = CurrentLevel.instance()
	call_deferred("add_child", PreviousLevelInstance)
	PreviousLevelInstance.position.x=-800
	
var PreviousLevel

func threaded_loading(path):
	var loader = ResourceLoader.load_interactive(path)
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			return loader.get_resource()
			
			break
	

func randomize_level(currentpath) -> String:
	var index = randi() % level_list.size()
	while level_list[index].path == currentpath:
		index = randi() % level_list.size()
	return level_list[index].path


func load_next(currentscene) -> void :
	PreviousLevelInstance = CurrentLevelInstance
	CurrentLevelInstance=currentscene
	var _currentpath = currentpath
	currentpath=randomize_level(_currentpath)
	NextLevelInstance=threaded_loading(currentpath).instance()
	call_deferred("add_child",NextLevelInstance)
	NextLevelInstance.position.x = CurrentLevelInstance.position.x+780
	pass

var heavendoonce=false

func _process(delta):
	GlobalStats.offset=offset
	if player.status == 3 && GlobalStats.level_type == GlobalStats.Level_Type.HEAVEN && !heavendoonce:
		heavendoonce=true
		Fader.fadein()
		GlobalStats.set_level_type(GlobalStats.Level_Type.NORMAL)
		get_tree().reload_current_scene()
		Fader.fadeout()
		
		pass
