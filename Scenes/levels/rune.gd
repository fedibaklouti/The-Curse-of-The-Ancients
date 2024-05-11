extends Area2D




onready var sprite= $Sprite

onready var sceneroot = get_tree().get_root().get_node("Game")

func _ready():
	if GlobalStats.runecount + 2 <= 8:
		sprite.frame = GlobalStats.runecount + 2
		var rng_spawn = randf()
		var rng_condition= randf()
		if GlobalStats.runecount == 0:
			rng_spawn=1
			rng_condition=1
		if GlobalStats.candrop==true && GlobalStats.PlayerScore >= GlobalStats.Rune_Target_Score[GlobalStats.runecount]:
			if (rng_spawn >= rng_condition):
				pass
			else:
				call_deferred("queue_free")

		if !GlobalStats.candrop && GlobalStats.PlayerScore < GlobalStats.Rune_Target_Score[GlobalStats.runecount]:
			call_deferred("queue_free")
		else:
				GlobalStats.candrop=true
	else:
		call_deferred("queue_free")
	pass 




func _on_rune_body_entered(body):
	if body.is_in_group("player"):
		body.specialscore(3)
		if GlobalStats.runecount + 1 < GlobalStats.runetarget:
			GlobalStats.runecount+=1
		GlobalStats.candrop=false
		GlobalStats.targetscore=GlobalStats.PlayerScore+5000
		call_deferred("queue_free")

