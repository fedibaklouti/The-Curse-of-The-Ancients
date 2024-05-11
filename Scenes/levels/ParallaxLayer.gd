extends ParallaxLayer


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if GlobalStats.PlayerStatus != 3:
		motion_offset.x-=motion_scale.x+GlobalStats.offset
