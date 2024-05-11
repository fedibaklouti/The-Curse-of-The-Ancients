extends Area2D

var hasloaded=false

func _ready():
	pass # Replace with function body.

func _on_loadzone_body_entered(body):
	if body.is_in_group("player") && !hasloaded:
		get_tree().get_root().get_node("Game").load_next(owner)
		hasloaded=true
	pass # Replace with function body.

