extends TileMap

var GameRoot

var staticBody := StaticBody2D.new()
var prevent_oob_collision := CollisionShape2D.new()
var shape := RectangleShape2D.new()

func _ready():
	GameRoot=get_tree().get_root().get_node("Game")
	if (GlobalStats.level_type != GlobalStats.Level_Type.HEAVEN):
		generateOOBBorder()
	

func generateOOBBorder(): 
	staticBody.collision_layer = collision_layer
	staticBody.collision_mask = collision_mask
	staticBody.position.y = 128
	staticBody.position.x = 16
	shape.extents = Vector2(16, 128)
	prevent_oob_collision.shape = shape
	call_deferred(
		"add_child", staticBody
	)
	staticBody.call_deferred(
		"add_child", prevent_oob_collision
	)	


func _physics_process(delta):
	if GlobalStats.PlayerStatus != 3: #MOVE LEVEL IF PLAYER ISNT DEAD
		position.x-=GlobalStats.BaseTileSpeed+GlobalStats.offset


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")

