extends Node3D
class_name Bullet

@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer

@export var speed: float = 15.0
@export var disappear_time: float = 0.75



func _ready() -> void:
	get_tree().create_tween().tween_callback(queue_free).set_delay(disappear_time)
	sound_player.play()


func _process(delta: float) -> void:
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Enemy:
		body.got_hit()
	queue_free()
