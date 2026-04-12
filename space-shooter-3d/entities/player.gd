extends CharacterBody3D

signal shoot(pos: Vector3)
signal player_hurt(lives_left: int)
signal game_over
const SPEED = 5.0
const JUMP_VELOCITY = 10
var tick_sec: float = 0.0
var hearts: int = 3


func _ready() -> void:
	%SpotLight3D.hide()


func _physics_process(delta: float) -> void:
	if hearts <= 0:
		rotate_z(-25.0)
		return
	## Handle altitiude shift.
	#if Input.is_action_just_pressed("move_up"):
		#velocity.y = JUMP_VELOCITY
	#elif Input.is_action_just_pressed("move_down") and !is_on_floor():
		#velocity.y = -JUMP_VELOCITY
	#else:
		#velocity.y = move_toward(velocity.y, 0, JUMP_VELOCITY)
	# Make altitude wobble
	
	tick_sec = (Time.get_ticks_msec()/1000.0)
	var velocity_y = (sin(tick_sec * 2) / 15) + (sin(tick_sec) / (randf()*100))
	velocity.y = move_toward(velocity.y, velocity_y, 2.0)
	
	if Input.is_action_just_pressed("shoot"):
		shoot.emit(global_position)

	# Handle movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$craft_speederA.rotation.z = move_toward($craft_speederA.rotation.z, -direction.x/5.0, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$craft_speederA.rotation.z = move_toward($craft_speederA.rotation.z, 0, delta)

	move_and_slide()


func got_hit() -> void:
	%SpotLight3D.show()
	$GotHitTimer.start()
	hearts -= 1
	$HurtAudio.play()
	player_hurt.emit(hearts)
	if hearts > 0:
		return
	game_over.emit()
	
func reset() -> void:
	hearts = 3
	var reset_tween = create_tween()
	reset_tween.tween_property(self, 'rotation:z', 0.0, 0.5)

func check_perf(_delta: float) -> void:
	var start = Time.get_ticks_usec()
	tick_sec = start/1000000.0
	#velocity.y = randf() * 10
	var velocity_y = (sin(tick_sec * 2) / 15) + (sin(tick_sec) / (randf()*100))
	velocity.y = move_toward(velocity.y, velocity_y, 2.0)
	var end = Time.get_ticks_usec()
	var worker_time = (end - start)/1000.0
	print("Worker time: %s ms" % [worker_time])


func _on_got_hit_timer_timeout() -> void:
	%SpotLight3D.hide()
