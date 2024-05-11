extends Control

onready var playerscore = $"scorevbox/scorehbox/Panel/scorehbox/score"
onready var panel = $"scorevbox/scorehbox/Panel"
onready var ammosprite=$"scorevbox/scorehbox/Container/ammo"
onready var deathvbox=$"cornervbox/Panel"
onready var RevolverCylinderSFX = $RevolverCylinderSFX
onready var hud_animator = $hud_animation
onready var specialmessage = $scorevbox/specialmessage
onready var runecount = $"scorevbox/scorehbox/CenterContainer/runecount"
onready var runetexture = $"scorevbox/scorehbox/CenterContainer/runetexture"
onready var deathText = $"cornervbox/Panel/deathhbox/deathtext"
onready var pausebutton = $scorevbox/scorehbox/pausebutton
onready var floatingRuneSprite = $"CenterContainer/Sprite"

var RetryString = ["Press R to try again", 
					"Tap to try again", 
					"Press START to try again"]

var tween= Tween.new()

enum controlType {keyboard, touch, controller}
var controlMode = controlType.keyboard

func _ready():
	add_child(tween)
	deathvbox.hide()
	runecount.set_text(str(GlobalStats.runecount))
	pass # Replace with function body.

var score=""
var length=0

var showPauseButton := false


func showPauseButton(
	show = false
): 
	pausebutton.visible = show


func _input(event):
	if Input.is_action_just_pressed("pause_game"): 
		showPauseButton(true)
		_on_pausebutton_pressed()

	if event is InputEventKey && controlMode != controlType.keyboard: 
		deathText.set_text(RetryString[0])
		controlMode = controlType.keyboard
		showPauseButton(false)
	if event is InputEventScreenTouch && controlMode != controlType.touch:
		deathText.set_text(RetryString[1])
		controlMode = controlType.touch
		showPauseButton(true)
	if event is InputEventJoypadButton && controlMode != controlType.controller:
		deathText.set_text(RetryString[2])
		controlMode = controlType.controller
		showPauseButton(false)

func specialscore(value,message):
	changescore(value)
	specialmessage=message
	hud_animator.queue("specialpopup")
	if value == 5000: #rune

		if GlobalStats.runecount + 2 > 8:
			floatingRuneSprite.frame = 8
		else: 
			floatingRuneSprite.frame = GlobalStats.runecount + 2
		$"AnimationPlayer".queue("rune_collected")

func changescore(value):
	score=str(round(value))
	length=len(score)+1
	playerscore.set_text(score)
	panel.rect_min_size.x=lerp(panel.rect_min_size.x,(length*5+68),0.2)
		

func death_ui(deathtype):
	deathvbox.show()
	pausebutton.set_disabled(true)
	$scorevbox/scorehbox/pausebutton/TextureRect.hide()
	pass



func update_ammo(ammo):
	var ammo_diff=ammosprite.frame - ammo
	ammosprite.frame=ammo
	if ammo_diff > 0:
		tween.interpolate_property(ammosprite,"rotation_degrees",ammosprite.rotation_degrees,ammosprite.rotation_degrees-60,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	else:
		tween.interpolate_property(ammosprite,"rotation_degrees",ammosprite.rotation_degrees,0,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
		if ammo_diff != 0:
			RevolverCylinderSFX.play()
	tween.start()

func changeRunes():
	runecount.set_text(str(int(runecount.get_text()) + 1))

func _on_hud_animation_animation_finished(anim_name):
	match anim_name:
		"specialpopup":
			yield(get_tree().create_timer(1),"timeout")
			hud_animator.queue("specialpopout")
	


func _on_pausebutton_pressed():
	var pausemenu = preload("res://GUI/PauseDialog.tscn").instance()
	add_child(pausemenu)
	pausemenu.visible = true

