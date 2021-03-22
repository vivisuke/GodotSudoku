extends RigidBody2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func setup(num):
	$Sprite.frame = num - 1
	rng.randomize()
	var th = rng.randf_range(0, 3.1415926535*2)
	print("th = ", th)
	linear_velocity = Vector2(cos(th), sin(th))*100
	angular_velocity = rng.randf_range(0, 10)
	
func set_number(num):
	#var s = $Sprite
	$Sprite.frame = num - 1
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
