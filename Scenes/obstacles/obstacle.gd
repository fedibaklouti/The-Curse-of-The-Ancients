extends Area2D

enum OBSTACLE_TYPE {lava, spike}

export (OBSTACLE_TYPE) var obstacle_type 


func _on_lava_body_entered(body):
	if body.is_in_group("player") && body.velocity.y >= 0:
		body.die(obstacle_type+2)

