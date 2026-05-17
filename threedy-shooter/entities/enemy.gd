extends CharacterBody3D
class_name Enemy

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var jump_timer: Timer = $JumpTimer

@export var attack_target: Player = null

const SPEED = 3.5
const JUMP_VELOCITY = 6.5

var hearts: int = 3
var health_tween: Tween

func _ready() -> void:
	if jump_timer.is_stopped():
		jump_timer.start()
		jump_timer.wait_time = randf_range(3.5, 9.5)
	if attack_target != null:
		nav_agent.set_target_position(attack_target.global_position)



func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var destination: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = (destination - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()


func _on_jump_timer_timeout() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	jump_timer.wait_time = randf_range(3.5, 9.5)
	if attack_target != null:
		nav_agent.set_target_position(attack_target.global_position)


func got_hit() -> void:
	hearts -= 1
	sound_player.play()
	print("ENEMY IS HIT.")
	turn_red()
	if hearts < 0:
		print("ENEMY DEAD.")
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
