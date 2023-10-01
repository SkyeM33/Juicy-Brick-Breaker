extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var tween = create_tween()

var powerup_prob = 0.1

func _ready():
	randomize()
	position.x = new_position.x
	position.y = -100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5).set_trans(Tween.TRANS_BOUNCE)

func _physics_process(_delta):
	if dying:
		queue_free()

func hit(_ball):
	die()

func die():
	dying = true
	var Camera = get_node_or_null("/root/Game/Camera2D")
	if Camera != null:
		Camera.add_trauma(3.0)
	$Confetti.emitting = true
	if tween:
		tween.kill()
	tween = create_tween()
	scale = Vector2(1,1)
	tween.tween_property($Brick_Sprite, "scale", Vector2(2,2), 0.5)
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position.x = position.x
			powerup.position.y = position.y
			var tween = create_tween()
			tween.tween_property(Powerup, "position", Vector2(position.x,$Brick_Sprite.position.y + 50), 0.5)
			Powerup_Container.call_deferred("add_child", powerup)

