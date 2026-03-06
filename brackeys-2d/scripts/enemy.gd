extends CharacterBody2D

@export var SPEED = 25.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
@onready var raycast_right = $RayCast2DRight
@onready var raycast_left = $RayCast2DLeft
@onready var animated_sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		direction = -1*(direction)
		animated_sprite.flip_h = !(animated_sprite.flip_h)
	velocity.x = direction * SPEED
	move_and_slide()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("SLIME KILLED YA")
	print(area.get_parent().get_node_or_null("CollisionShape2D"))
	area.get_parent().find_child("CollisionShape2D").queue_free()
