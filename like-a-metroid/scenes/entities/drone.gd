extends CharacterBody2D


const SPEED = 75.0
var target_body: Node2D = null
var direction: Vector2 = Vector2.ZERO
var hearts: int = 3
var rotated_by: float = 0.0


func _ready() -> void:
	var light_tween = create_tween()
	light_tween.set_loops()
	light_tween.tween_property(%PointLight2D, "energy", 2.5, 0.3)
	light_tween.tween_property(%PointLight2D, "energy", 0.75, 0.05)


func _physics_process(_delta: float) -> void:
	if target_body:
		direction = (target_body.position - position).normalized()
		velocity.x = direction.x * SPEED
		%AnimatedSprite2D.flip_h = direction.x > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


func _on_sensory_range_body_entered(body: Node2D) -> void:
	target_body = body


func _on_sensory_range_body_exited(_body: Node2D) -> void:
	if is_queued_for_deletion():
		return
	if %TrackTimer.is_stopped():
		return
	%TrackTimer.start()


func _on_track_timer_timeout() -> void:
	if is_queued_for_deletion():
		return
	target_body = null


func _on_hurtbox_body_entered(_body: Node2D) -> void:
	if is_queued_for_deletion():
		return
	got_hit()


func drop_y(val: float) -> void:
	velocity.y = val
	move_and_slide()
	%DropTimer.start()


func got_hit() -> void:
	hearts -= 1
	var rand_rotation = randf()
	rotated_by += rand_rotation
	rotate(rand_rotation)
	%RotateTimer.start()
	if hearts > 0:
		var material_tween = create_tween()
		material_tween.tween_property(%AnimatedSprite2D.material, 'shader_parameter/Progress', 0.9, 0.3)
		material_tween.tween_property(%AnimatedSprite2D.material, 'shader_parameter/Progress', 1.0, 0.1)
		return
	%AnimatedSprite2D.play("explosion")
	%AudioStreamPlayer2D.play()
	neighbour_impact()
	await %AnimatedSprite2D.animation_finished
	queue_free()


func neighbour_impact() -> void:
	for d in get_tree().get_nodes_in_group("Drones"):
		if d == self || position.distance_to(d.position) > 40:
			continue
		d.drop_y(10)
		d.got_hit()


func _on_drop_timer_timeout() -> void:
	if is_queued_for_deletion():
		return
	velocity.y = move_toward(velocity.y, 0, SPEED)


func _on_rotate_timer_timeout() -> void:
	if is_queued_for_deletion():
		return
	rotate(-rotated_by)
	rotated_by = 0.0
