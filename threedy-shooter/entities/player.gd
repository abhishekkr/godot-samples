extends CharacterBody3D
class_name Player

@export var camera_pivot: Camera3D
@export var my_weapon: PackedScene
@export var my_bullet: PackedScene
@export var muzzle_speed: float = 15.0
@export var millisecond_fire_interval: float = 500.0
@export var bullet_pool_size := 10
var bullet_pool: Array[Bullet] = []
var bullet_pool_index := 0

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
	var input_dir3D = Vector3(input_dir.x, 0, input_dir.y)
	#direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = input_dir3D.rotated(Vector3.UP, camera_pivot.global_rotation.y)


func equip_weapon() -> void:
	if not my_weapon:
		print("No Weapon Given.")
		return
	if weapon_controller.get_child_count() > 0:
		print("Redundant call made to equip weapon.")
		return
	var weapon = my_weapon.instantiate()
	#weapon.transform = hand.transform
	#weapon.position = hand.global_transform.origin
	weapon.rotate_z(deg_to_rad(-90))
	weapon.scale = Vector3(0.75, 0.75, 0.75)
	weapon_controller.add_child(weapon)
	shot_origin_transform = weapon.get_barrel_end_transform()
	## create bullet pool
	bullet_pool.resize(bullet_pool_size)
	for i in bullet_pool_size:
		var b = my_bullet.instantiate()
		get_tree().current_scene.add_child.call_deferred(b)
		b.deactivate()
		bullet_pool[i] = b


func do_shoot() -> void:
	if not shoot_interval.is_stopped():
		return
	if not my_bullet:
		print("Got no bullets.")
		return
	shoot_interval.start()
	print("~~~1 do_shoot: ", Time.get_ticks_msec())
	var bullet = bullet_pool[bullet_pool_index]
	bullet_pool_index = (bullet_pool_index + 1) % bullet_pool_size
	bullet.activate(weapon_controller.global_transform, muzzle_speed)
	#var bullet = my_bullet.instantiate()
	print("~~2 do_shoot: ", Time.get_ticks_msec())
	#bullet.transform = shot_origin_transform
	#bullet.speed = muzzle_speed
	#weapon_controller.add_child(bullet)
