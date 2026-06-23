extends CharacterBody3D
class_name Enemy

signal death

@export var my_weapon: PackedScene = preload("res://entities/spear.tscn")
@export var weapon_swing_speed: float = 15.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var jump_timer: Timer = $JumpTimer

@onready var hand: Marker3D = $BodyMesh/Hand
@onready var weapon_controller: Node3D = $BodyMesh/Hand/WeaponController
@onready var swing_timer: Timer = $SwingTimer

@export var attack_target: Player = null

const SPEED = 105
const JUMP_VELOCITY = 2.5

var hearts: int = 3
var health_tween: Tween
var has_target: bool = false
var can_attack: bool = false


func _ready() -> void:
	if jump_timer != null and jump_timer.is_stopped():
		jump_timer.start()
		jump_timer.wait_time = randf_range(1.5, 3.5)
	if attack_target != null and nav_agent != null:
		set_target()
	if my_weapon:
		equip_weapon()


func _process(delta: float) -> void:
	if WaveManager.is_game_over:
		swing_timer.stop()
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	if can_attack:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	elif has_target:
		move_to_target(delta)
	move_and_slide()


func _on_jump_timer_timeout() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	jump_timer.wait_time = randf_range(3.5, 9.5)
	if attack_target != null:
		set_target()


func _on_navigation_agent_3d_navigation_finished() -> void:
	print("ENEMY: Player In Sight")


func set_target() -> void:
	has_target = true
	nav_agent.set_target_position(attack_target.global_position)


func move_to_target(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		has_target = false
		velocity = Vector3.ZERO
		return
	var destination: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = (destination - global_transform.origin).normalized()
	velocity = direction * SPEED * delta
	rotate_to_direction(delta, direction)


func rotate_to_direction(delta: float, direction: Vector3) -> void:
	var rotation_speed = 5
	var target_rotation := direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	if abs(target_rotation - rotation.y) > deg_to_rad(60):
		rotation_speed = 20
	rotation.y = move_toward(rotation.y, target_rotation, delta * rotation_speed)


func got_hit() -> void:
	hearts -= 1
	sound_player.play()
	turn_red()
	set_target()
	if hearts < 0:
		death.emit()
		await health_tween.finished
		queue_free()


func turn_red() -> void:
	if health_tween and health_tween.is_running():
		return
	var body_material: Material = $BodyMesh.get_active_material(0)
	health_tween = create_tween()
	health_tween.set_parallel(true)
	health_tween.tween_property(body_material, "albedo_color", Color.RED, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(body_material, "albedo_color", Color.SKY_BLUE, 0.05).set_delay(0.5)


func equip_weapon() -> void:
	if not my_weapon:
		print("No Weapon Given.")
		return
	if weapon_controller.get_child_count() > 0:
		print("Redundant call made to equip weapon.")
		return
	var weapon = my_weapon.instantiate()
	#weapon.rotate_z(deg_to_rad(-90))
	#weapon.scale = Vector3(0.75, 0.75, 0.75)
	weapon_controller.add_child(weapon)


func _on_attack_radius_body_entered(body: Node3D) -> void:
	if body is Player:
		print("CAN ATTACK")
		can_attack = true
		swing_timer.start()


func _on_attack_radius_body_exited(body: Node3D) -> void:
	if body is Player:
		can_attack = false
		swing_timer.stop()


func _on_swing_timer_timeout() -> void:
	var weapon_tween = get_tree().create_tween()
	weapon_tween.set_parallel(false)
	weapon_tween.tween_property(weapon_controller, "rotation_degrees:x", 90.0, 0.5)
	weapon_tween.tween_property(weapon_controller, "rotation_degrees:x", 0.0, 0.5)
	
