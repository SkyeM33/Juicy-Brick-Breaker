extends RigidBody2D

var min_speed = 100.0
var max_speed = 600.0
var speed_multiplier = 1.0
var accelerate = false
var tween = create_tween()
var time_highlight = 0.4
var h_rotate = 0.0

var released = true

var initial_velocity = Vector2.ZERO

func _ready():
	contact_monitor = true
	max_contacts_reported = 8
	if Global.level < 0 or Global.level >= len(Levels.levels):
		Global.end_game(true)
	else:
		var level = Levels.levels[Global.level]
		min_speed *= level["multiplier"]
		max_speed *= level["multiplier"]
	

func _on_Ball_body_entered(body):
	$Confetti.emitting = true
	if body.has_method("hit"):
		body.hit(self)
		accelerate = true
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	$Highlight.modulate.a = 1.0
	tween.tween_property($Highlight, "modulate:a", 0, time_highlight)

func _input(event):
	if not released and event.is_action_pressed("release"):
		apply_central_impulse(initial_velocity)
		released = true

func _integrate_forces(state):
	if not released:
		var paddle = get_node_or_null("/root/Game/Paddle_Container/Paddle")
		if paddle != null:
			state.transform.origin = Vector2(paddle.position.x, paddle.position.y - 30)	

	if position.y > Global.VP.y + 100:
		die()
	if accelerate:
		state.linear_velocity = state.linear_velocity * 1.1
		accelerate = false
	if abs(state.linear_velocity.x) < min_speed * speed_multiplier:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed * speed_multiplier
	if abs(state.linear_velocity.y) < min_speed * speed_multiplier:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed * speed_multiplier
	if state.linear_velocity.length() > max_speed * speed_multiplier:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed * speed_multiplier

func change_size(s):
	$ColorRect.scale = s
	$CollisionShape2D.scale = s

func change_speed(s):
	speed_multiplier = s
	
func comet():
	var Comet_Container = get_node_or_null("/root/Game/Comet_Container")
	if Comet_Container != null:
		var sprite = $Sprite2D.duplicate()
		sprite.global_position = global_position
		Comet_Container.add_child(sprite)

func die():
	var die_sound = get_node("/root/Game/Death_Sound")
	die_sound.play()
	queue_free()
