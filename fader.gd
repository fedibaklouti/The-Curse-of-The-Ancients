extends CanvasLayer

onready var colorrect= $ColorRect
onready var animator= $AnimationPlayer


func _ready():
	colorrect.visible=false
	pass
	
func fadein():
#	colorrect.color=color
	animator.stop()
	animator.play("fadein")
	pass
	
func fadeout():
	animator.stop()
	animator.play("fadeout")
	pass
