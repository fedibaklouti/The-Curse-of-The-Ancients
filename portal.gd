extends Area2D

var TypeLevel = [GlobalStats.Level_Type.NORMAL,GlobalStats.Level_Type.HELL, GlobalStats.Level_Type.HEAVEN]
export (Color) var HellPortalColor
export (Color) var HeavenPortalColor
export (Color) var NormalPortalColor

onready var sprite = $sprite
onready var light = $Sprite2

export (float, 0, 100) var Chance_To_Spawn = 10
var chance
var rng_spawn

var i 
func _ready():
	chance = 1-(Chance_To_Spawn/100)
	rng_spawn = randf()
	if rng_spawn >= chance:
		match GlobalStats.level_type:
			GlobalStats.Level_Type.HELL,GlobalStats.Level_Type.HEAVEN:
				i=0
			_:
				i = randi() % 2  
				while i == GlobalStats.level_type:
					i = randi()%3
		match i:
			GlobalStats.Level_Type.NORMAL:
				sprite.modulate=NormalPortalColor
				light.self_modulate=NormalPortalColor
			GlobalStats.Level_Type.HELL:
				sprite.modulate=HellPortalColor
				light.self_modulate=HellPortalColor
			GlobalStats.Level_Type.HEAVEN:
				sprite.modulate=HeavenPortalColor
				light.self_modulate=HeavenPortalColor
	else:
				call_deferred("queue_free")
	
	
	#$Lava.texture= load(listTexture[i])

func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		match i:
			GlobalStats.Level_Type.NORMAL:
				Fader.colorrect.color=NormalPortalColor
			GlobalStats.Level_Type.HELL:
				Fader.colorrect.color=HellPortalColor
			GlobalStats.Level_Type.HEAVEN:
				Fader.colorrect.color=HeavenPortalColor
		Fader.fadein()
		GlobalStats.set_level_type(TypeLevel[i])
		get_tree().reload_current_scene()
		
