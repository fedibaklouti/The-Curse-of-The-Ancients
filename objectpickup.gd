extends Area2D

func _ready():
	pass 




func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.add_ammo()
		queue_free()
	pass # Replace with function body.
