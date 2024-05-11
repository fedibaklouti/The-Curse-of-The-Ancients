extends KinematicBody2D

signal scorechanged
signal ammochanged
signal specialscore
signal died

#SOUND EFFECT REPOSITORY
var NoAmmoSFX = "res://Audio/SFX/Weapons/NoAmmo.wav"

var RevolverSFX = ["res://Audio/SFX/Weapons/RevolverShot02.wav",
					"res://Audio/SFX/Weapons/RevolverShot03.wav"]
var ShellSFX = ["res://Audio/SFX/Weapons/shelldrop01.wav"
				,"res://Audio/SFX/Weapons/shelldrop02.wav",
				"res://Audio/SFX/Weapons/shelldrop03.wav"]
var RicochetSFX = ["res://Audio/SFX/Ricochet/ricochet01.wav",
					"res://Audio/SFX/Ricochet/ricochet02.wav",
					"res://Audio/SFX/Ricochet/ricochet03.wav"]
var LeftFootSFX = ["res://Audio/SFX/Footsteps/left01.wav",
					"res://Audio/SFX/Footsteps/left02.wav",
					"res://Audio/SFX/Footsteps/left03.wav"]
var RightFootSFX=["res://Audio/SFX/Footsteps/right01.wav",
					"res://Audio/SFX/Footsteps/right02.wav",
					"res://Audio/SFX/Footsteps/right03.wav"]

var JUMPHEIGHT = 580
var GRAVITY = 40
var velocity = Vector2.ZERO
var UP = Vector2.UP
var GameRoot
var CanSlide=true
var CanShoot=true
var DeathAnimationFinished=false
onready var Animator = $AnimationPlayer
onready var GunAnimator =$gunnode/AnimationPlayer
onready var PlayerCamera = $Camera2D
onready var CameraZoom = 1.7777/(OS.get_window_size().x/OS.get_window_size().y)
var tween = Tween.new()
var tween2 = Tween.new()
var ammo=6



#NODES LIST
#CASTS:
onready var forwardcast = $forwardcast #check infront of you (walls)
onready var upcast = $upcast #check above you
onready var shootarea = $shootarea #bullet raycast
onready var floorcast = $downcast

enum Player_Deaths {HIT_WALL=0, HIT_ENEMY=1, HIT_LAVA=2, HIT_SPIKE=3}
enum Player_Stats {IS_RUNNING=0, IS_JUMPING=1, IS_SLIDING=2, IS_DYING=3}
var status=0

func add_ammo():
	ammo=6
	emit_signal("ammochanged",ammo)

func is_on_floor() -> bool:
	return floorcast.is_colliding()
	pass

func _ready():
	emit_signal("ammochanged",ammo)
	$gunnode/muzzleflash.hide()
	PlayerCamera.offset=Vector2(100,0)
	call_deferred("add_child", tween)
	call_deferred("add_child", tween2)
	tween.interpolate_property($AnimationPlayer, "playback_speed",1.35,1.9,100,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
	tween.start()
	$Sprite.show()
	$deathsprite.hide()
	GameRoot=get_tree().get_root().get_node("Game")
	pass # Replace with function body.



func shoot():
	if GlobalStats.level_type != GlobalStats.Level_Type.HEAVEN:
		if ammo > 0:
			ammo-=1
			emit_signal("ammochanged",ammo)
			$gunnode/muzzleflash.offset=$gunnode/gun.offset
			$gunnode/muzzleflash.frame=randi()%3
			GunAnimator.play("shoot")
			var currentposition=global_position
			GlobalStats.play_sfx(RevolverSFX[randi()%RevolverSFX.size()],rand_range(-2,-1),currentposition)
			$shoottimer.start()
			shootarea.monitoring=true
			shootarea.monitorable=true
			CanShoot=false
			yield(get_tree().create_timer(0.05),"timeout")
			shootarea.monitoring=false
			shootarea.monitorable=false
			yield(get_tree().create_timer(rand_range(0.2,0.8)),"timeout")
			GlobalStats.play_sfx(ShellSFX[randi()%ShellSFX.size()],int(rand_range(-20,-12)),Vector2(currentposition.x-rand_range(200,500),0))
		else:
			GlobalStats.play_sfx(NoAmmoSFX,rand_range(-2,-1),position)
			$shoottimer.start()
			CanShoot=false
		pass
	

func _input(event):
	var swipe = Vector2(0,0)
	
	if GlobalStats.level_type == GlobalStats.Level_Type.HEAVEN: 
		if event is InputEventScreenDrag:
			swipe = event.relative
			velocity.y+=swipe.y * 2
	
	if status != Player_Stats.IS_DYING:
		if event is InputEventScreenDrag:
			JUMPHEIGHT = 580
			swipe = event.relative
			if swipe.y < -15 && is_on_floor() && !upcast.is_colliding() && status != Player_Stats.IS_JUMPING: 
				velocity.y -= JUMPHEIGHT
				status=Player_Stats.IS_JUMPING
			if swipe.y > 10 && is_on_floor() && CanSlide: 
				status=Player_Stats.IS_SLIDING
				$slidetimer.start()
				CanSlide=false
				forwardcast.position.y=8
			if swipe.x < -30 && CanShoot: 
				shoot()

		if Input.is_action_just_pressed("player_shoot") && CanShoot: #Shooting
			shoot()
		if Input.is_action_just_pressed("player_jump") && is_on_floor() && !upcast.is_colliding(): #Jumping
			JUMPHEIGHT = 640
			velocity.y -= JUMPHEIGHT
			status=Player_Stats.IS_JUMPING
		if Input.is_action_just_pressed("player_slide") && is_on_floor() && CanSlide: #Sliding
			status=Player_Stats.IS_SLIDING
			$slidetimer.start()
			CanSlide=false
			forwardcast.position.y=8
#



func heaven_controls():
	if Input.is_action_pressed("player_up"):
		velocity.y-=10
		if Animator.get_current_animation() != "jet_fly":
			Animator.play("jet_fly")
	if Input.is_action_pressed("player_down"):
		velocity.y+=10
	position.y=clamp(position.y,-500,500)
	if status!=Player_Stats.IS_DYING:
		changescore(0.35)
	if forwardcast.is_colliding() || upcast.is_colliding() || floorcast.is_colliding():
		die(0)
		#Fader.colorrect.color=NormalPortalColor
	
	
	pass


func CameraSystem():
	PlayerCamera.zoom=lerp(PlayerCamera.zoom,Vector2(CameraZoom,CameraZoom),0.2)
	
	
	pass

enum Special_Score_Types {KILL_ENEMY, SLIDE_ON_ENEMY}

var Special_Score_Messages= ["Enemy Down! +200"
							, "Enemy has ate the dirt! +150"]


func specialscore(type):
	match type:
		Special_Score_Types.KILL_ENEMY:
			GlobalStats.PlayerScore+=200
			emit_signal("specialscore",200,Special_Score_Messages[type])
		Special_Score_Types.SLIDE_ON_ENEMY:
			GlobalStats.PlayerScore+=150
			emit_signal("specialscore",150,Special_Score_Messages[type])
		3:
			GlobalStats.PlayerScore+=5000
			emit_signal("specialscore",5000,"Rune Collected! +5000")

func changescore(amount):
	GlobalStats.PlayerScore+=amount
	emit_signal("scorechanged",GlobalStats.PlayerScore)


func die(death_type):
	status=Player_Stats.IS_DYING
	emit_signal("died",death_type)
	CameraZoom=0.6
	match death_type:
		Player_Deaths.HIT_WALL, Player_Deaths.HIT_SPIKE:
			if !DeathAnimationFinished: #play death animation only once
				Animator.play("playerwalldeath")
		Player_Deaths.HIT_LAVA:
			Animator.play("PlayerDieLava")
	pass


func animation_system():
	if GlobalStats.level_type == GlobalStats.Level_Type.HEAVEN && status != Player_Stats.IS_DYING:
		Animator.play("jet_fly")
	
	if status != Player_Stats.IS_DYING && GlobalStats.level_type != GlobalStats.Level_Type.HEAVEN:
		if status==Player_Stats.IS_JUMPING:
			if velocity.y < 0:
				Animator.play("Playersjump")
			else:
				Animator.play("Playersfall")
		if velocity.y > 0:
			Animator.play("Playersfall")
		if status == Player_Stats.IS_SLIDING:
			Animator.play("Playersslide")
		if status==Player_Stats.IS_RUNNING && is_on_floor():
			Animator.play("Playersrun")

var doonce=false
var hitonce=false


func _physics_process(delta):

	$Label.set_text(str(velocity))
	GlobalStats.PlayerStatus=status
	CameraSystem()
	animation_system()
	if GlobalStats.level_type == GlobalStats.Level_Type.HEAVEN:
		heaven_controls()
	if GlobalStats.level_type != GlobalStats.Level_Type.HEAVEN:
		if !is_on_floor():
			velocity.y+=GRAVITY
		
		if forwardcast.is_colliding() && !doonce:
			die(Player_Deaths.HIT_WALL)
			doonce=true
		if status!=Player_Stats.IS_DYING:
			if is_on_floor() && status!=Player_Stats.IS_SLIDING:
				status=Player_Stats.IS_RUNNING
			if status!=Player_Stats.IS_DYING:
				changescore(0.2)
	velocity.y=clamp(velocity.y, -JUMPHEIGHT,JUMPHEIGHT*2)
	velocity=move_and_slide(velocity,UP)

func check_ceiling_slide():
	if status != Player_Stats.IS_DYING:
		if upcast.is_colliding():
			$slidetimer.start()
			CanSlide=false
		else:
			status=Player_Stats.IS_RUNNING
			forwardcast.position.y=0
			$slidecooldown.start()


func _on_slidetimer_timeout():
	check_ceiling_slide()


#camera shake on shoot
func shake_camera():
	tween2.remove_all()
	var shakestrength=Vector2(rand_range(0.5,3.5),rand_range(-2.5,2.5))
	PlayerCamera.position=shakestrength
	tween2.interpolate_property(PlayerCamera,"position",PlayerCamera.position,-shakestrength,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween2.interpolate_property(PlayerCamera,"position",PlayerCamera.position,Vector2(0,0),0.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween2.start() 
	
	


#FOOTSTEP SCRIPT
func left_footstep():
	GlobalStats.play_sfx(LeftFootSFX[randi()%LeftFootSFX.size()],-6,position)
	
func right_footstep():
	GlobalStats.play_sfx(RightFootSFX[randi()%RightFootSFX.size()],-6,position)
	

func _on_slidecooldown_timeout():
	CanSlide=true


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"playerwalldeath":
			DeathAnimationFinished=true
	pass # Replace with function body.


func _on_shoottimer_timeout():
	CanShoot=true
	pass # Replace with function body.


func _on_shootarea_body_entered(body):
	var rng_ricochet = randf()
	if rng_ricochet > 0.7:
		yield(get_tree().create_timer(rand_range(0,0.3)),"timeout")
		GlobalStats.play_sfx(RicochetSFX[randi()%RicochetSFX.size()],rand_range(-10,-6),Vector2(position.x+500,position.y))
		print("soundplayed")
	pass # Replace with function body.
