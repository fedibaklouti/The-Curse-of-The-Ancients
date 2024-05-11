extends Area2D

onready var rune = preload("res://Scenes/levels/rune.tscn").instance()
onready var wallcast = $wallcast
onready var animator = $AnimationPlayer
onready var sceneroot = get_tree().get_root().get_node("Game")
onready var blood = $"Sprite/blood"
enum enemy_status {chaseplayer, blockplayer, chargeplayer}
export(enemy_status) var status=enemy_status.blockplayer
export (float, 0, 100) var Chance_To_Spawn = 0.5
enum enemy_type {mummy, hellhound}
export (enemy_type) var ENEMY = enemy_type.mummy
var alive:=true
var chance
var rng_spawn

func _ready():
	if ENEMY == enemy_type.mummy:
		if has_node("die_on_wall"):
			$"die_on_wall".visible=false
	$Sprite.visible=true
	monitorable=true
	monitoring=true
	blood.emitting=false
	chance = 1-(Chance_To_Spawn/100)
	rng_spawn = randf()
	match status:
		enemy_status.chargeplayer:
			animator.play("hellhound_chase")
			$AudioStreamPlayer2D.stream=load("res://Audio/SFX/hellhound.wav")
			$AudioStreamPlayer2D.play()
		enemy_status.chaseplayer:
			$AudioStreamPlayer2D.stream=load("res://Audio/SFX/mummybreathing.wav")
			$AudioStreamPlayer2D.play()
			animator.play("walk")
			
		enemy_status.blockplayer:
			if rng_spawn >= chance:
				animator.play("block")
			else:
				call_deferred("queue_free")

			pass
	pass # Replace with function body.




func spawn_rune():
	if status != enemy_status.chaseplayer:
		if !GlobalStats.candrop && GlobalStats.PlayerScore < GlobalStats.Rune_Target_Score[GlobalStats.runecount]:
			pass
		else:
				GlobalStats.candrop=true
				owner.call_deferred("add_child", rune)
				rune.position=position
	pass




var dieonce=false
var dead=false
enum death_type {get_shot, collide}

func die(death):
	spawn_rune()
	match death:
		death_type.get_shot:
			if ENEMY == enemy_type.hellhound:
				animator.play("hellhound_death")
			else:
				animator.play("die")
		death_type.collide:
			if ENEMY == enemy_type.mummy:
				animator.play("die_on_wall")
				dead=true
		_:
			call_deferred("queue_free")
	pass
	
func kill():
	
	pass

func _physics_process(delta):
	if dead:
		position.x-=GlobalStats.BaseTileSpeed+GlobalStats.offset
	if status == enemy_status.chargeplayer && alive :
		position.x -= 1
	if wallcast.is_colliding() && !dieonce:
		dieonce=true
		die(1)


func _on_mummy_area_entered(area):
	if area.is_in_group("bullet"):
		die(death_type.get_shot)
		sceneroot.player.specialscore(0)
	pass # Replace with function body.


func _on_mummy_body_entered(body):
	if body.is_in_group("player"):
		body.die(0)
		if has_node("demon_laugh"):
			$demon_laugh.play()
	pass # Replace with function body.
