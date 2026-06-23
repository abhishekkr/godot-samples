extends Node3D
class_name Bullet

@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bullet_hitbox: Area3D = $Hitbox

@export var speed: float = 15.0
@export var disappear_time: float = 0.75

var active: bool


func _ready() -> void:
	active = false


func _process(delta: float) -> void:
	if active:
		var forward_direction = global_transform.basis.z.normalized()
		global_translate(forward_direction * speed * delta)


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Enemy:
		body.got_hit()
	deactivate()


func activate(spawn_transform: Transform3D, nu_speed: float):
	global_transform = spawn_transform
	speed = nu_speed
	if bullet_hitbox:
		bullet_hitbox.set_deferred("monitorable", true)
		bullet_hitbox.set_deferred("monitoring", true)
	active = true
	get_tree().create_tween().tween_callback(deactivate).set_delay(disappear_time)
	show()
	sound_player.play()


func deactivate():
	if bullet_hitbox:
		bullet_hitbox.set_deferred("monitorable", false)
		bullet_hitbox.set_deferred("monitoring", false)
	active = false
	hide()
