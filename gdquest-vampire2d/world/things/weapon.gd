extends Area2D


@onready var bullet = preload("res://world/things/bullet_projectile.tscn")
@onready var barrel_marker = %BarrelMarker


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()
	elif event.is_action_pressed("shoot_at"):
		look_at(event.position)
		shoot()


func shoot() -> void:
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = barrel_marker.global_position
	new_bullet.global_rotation = barrel_marker.global_rotation
	add_child(new_bullet)


func _on_timer_timeout() -> void:
	var bodies_in_range = get_overlapping_bodies()
	if bodies_in_range.size() > 0:
		var first_body = bodies_in_range.front()
		look_at(first_body.global_position)
