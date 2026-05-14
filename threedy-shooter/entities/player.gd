extends CharacterBody3D
class_name Player

@export var my_weapon: PackedScene
@export var my_bullet: PackedScene
@export var muzzle_speed: float = 15.0
@export var millisecond_fire_interval: float = 500.0
@onready var hand: Marker3D = $BodyMesh/Hand
@onready var weapon_controller: Node3D = $BodyMesh/Hand/WeaponController
@onready var shoot_interval: Timer = $ShootIntervalTimer
var shot_origin_transform: Transform3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.5
var direction: Vector3


func _ready() -> void:
	if my_weapon:
		equip_weapon()
		shoot_interval.one_shot = true
		shoot_interval.wait_time = millisecond_fire_interval / 1000


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if not event.is_echo():
		if event.is_action_pressed("do_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if event.is_action_pressed("do_shoot"):
			do_shoot()
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


func _on_shoot_interval_timer_timeout() -> void:
	print("ready_to_shoot")


func equip_weapon() -> void:
	if not my_weapon:
		print("No Weapon Given.")
		return
	if weapon_controller.get_child_count() > 0:
		print("Redundant call made to equip weapon.")
		return
	var weapon = my_weapon.instantiate()
	weapon.transform = hand.transform
	weapon.rotate_z(deg_to_rad(180))
	weapon.scale = Vector3(0.75, 0.75, 0.75)
	weapon_controller.add_child(weapon)
	shot_origin_transform = weapon.get_barrel_end_transform()


func do_shoot() -> void:
	if not shoot_interval.is_stopped():
		print("In between shots.")
		return
	if not my_bullet:
		print("Got no bullets.")
		return
	shoot_interval.start()
	var bullet = my_bullet.instantiate()
	bullet.transform = shot_origin_transform
	bullet.speed = muzzle_speed
	weapon_controller.add_child(bullet)
