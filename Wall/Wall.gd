extends StaticBody2D

var decay = 0.01

func _ready():
	pass

func _physics_process(_delta):
	pass

func hit(_ball):
	var tween = create_tween()
	scale = Vector2(2,2)
	tween.tween_property(self, "scale", Vector2(1,1), 0.5)
	$ColorRect.color = Color8(201,42,42)
	tween.tween_property($ColorRect, "color", Color8(255,255,255), 0.5)
	var Camera = get_node_or_null("/root/Game/Camera2D")
	if Camera != null:
		Camera.add_trauma(3.0)
