extends Node

var PlayerStatus
var PlayerScore = 0
var offset=0
var BaseTileSpeed = 4.8
var audioplayerpath=preload("res://Scenes/Audio/AudioPlayer.tscn")

var targetscore=0
var candrop=true
var runecount=-1
var runetarget=7


var normal_level_list= [
	{"instance": preload("res://Scenes/levels/TestTileMap.tscn"), "path":"res://Scenes/levels/TestTileMap.tscn"}, 
	{"instance": preload("res://Scenes/levels/TestTileMap2.tscn"), "path":"res://Scenes/levels/TestTileMap2.tscn"}, 
	{"instance": preload("res://Scenes/levels/TestTileMap3.tscn"), "path":"res://Scenes/levels/TestTileMap3.tscn"},
	{"intsance": preload("res://Scenes/levels/TestTileMap4.tscn"), "path":"res://Scenes/levels/TestTileMap4.tscn"}, 
	{"instance": preload("res://Scenes/levels/TestTileMap5.tscn"), "path": "res://Scenes/levels/TestTileMap5.tscn"},
	{"instance": preload("res://Scenes/levels/block1.tscn"), "path":"res://Scenes/levels/block1.tscn"},
	{"instance": preload("res://Scenes/levels/block2.tscn"), "path":"res://Scenes/levels/block2.tscn"},
	{"instance": preload("res://Scenes/levels/block3.tscn"), "path":"res://Scenes/levels/block3.tscn"},
	{"instance": preload("res://Scenes/levels/block4.tscn"), "path":  "res://Scenes/levels/block4.tscn"},
	{"instance": preload("res://Scenes/levels/block5.tscn"), "path":  "res://Scenes/levels/block5.tscn"}, 
	{"instance": preload("res://Scenes/levels/block6.tscn"), "path": "res://Scenes/levels/block6.tscn"}
]

var hell_level_list=[
	{"instance": preload("res://Scenes/levels/hell/block0.tscn"), "path":"res://Scenes/levels/hell/block0.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block1.tscn"), "path":"res://Scenes/levels/hell/block1.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block2.tscn"), "path":"res://Scenes/levels/hell/block2.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block3.tscn"), "path":"res://Scenes/levels/hell/block3.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block4.tscn"), "path":  "res://Scenes/levels/hell/block4.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block5.tscn"), "path":  "res://Scenes/levels/hell/block5.tscn"}, 
	{"instance": preload("res://Scenes/levels/hell/block6.tscn"), "path": "res://Scenes/levels/hell/block6.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block7.tscn"), "path": "res://Scenes/levels/hell/block7.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block8.tscn"), "path": "res://Scenes/levels/hell/block8.tscn"},
	{"instance": preload("res://Scenes/levels/hell/block9.tscn"), "path": "res://Scenes/levels/hell/block9.tscn"},
]
var heaven_level_list= [
	{"instance": preload("res://Scenes/levels/heaven/block0.tscn"), "path":"res://Scenes/levels/heaven/block0.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block01.tscn"), "path":"res://Scenes/levels/heaven/block01.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block02.tscn"), "path":"res://Scenes/levels/heaven/block02.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block3.tscn"), "path":"res://Scenes/levels/heaven/block3.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block4.tscn"), "path":  "res://Scenes/levels/heaven/block4.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block5.tscn"), "path":  "res://Scenes/levels/heaven/block5.tscn"}, 
	{"instance": preload("res://Scenes/levels/heaven/block6.tscn"), "path": "res://Scenes/levels/heaven/block6.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block7.tscn"), "path": "res://Scenes/levels/heaven/block7.tscn"},
	{"instance": preload("res://Scenes/levels/heaven/block8.tscn"), "path": "res://Scenes/levels/heaven/block8.tscn"}
	]


enum Level_Type {NORMAL, HELL, HEAVEN}

var Rune_Target_Score=[1000, 2000, 3000, 5000, 7500, 8000, 10000]

var level_type = Level_Type.NORMAL

func set_level_type(Name): 
	level_type = Name

func play_sfx(path,volume,position):
	var audioplayer = audioplayerpath.instance()
	get_tree().get_root().get_node("Game").call_deferred("add_child",audioplayer)
	audioplayer._play(path,volume,position)
	
