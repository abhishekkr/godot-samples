
extends Node3D

@export var ground_length: float = 8
@export var ground_breadth: float = 6

@onready var level = %Level

@onready var player: Player = $Temp/Player
@onready var test_timer: Timer = $Temp/TestTimer
@onready var camera: Camera3D = $Temp/Camera3D2
@onready var nfo_label: Label = $TempHUD/Control/Iteration
var counter := 0

var spawn_points: Array = []

enum WALL_ALIGNMENT {
	VERTICAL,
	HORIZONTAL,
	BOTH,
}
var wall_position_set: Dictionary = {}


func _ready() -> void:
	generate_map()
	WaveManager.set_restart_configs()
	WaveManager.start_next_wave()
	test_timer.start()
	set_nfo()


func _on_test_timer_timeout() -> void:
	ground_length += 2
	ground_breadth += 1.25
	clear_map()
	generate_map()
	WaveManager.on_game_restart()
	WaveManager.start_next_wave()
	set_nfo()
	var cam_tween = get_tree().create_tween()
	var new_cam_pos = Vector3(camera.position.x, camera.position.y+1.0, camera.position.z+0.65)
	cam_tween.tween_property(camera, "position", new_cam_pos, 1.0)
	await cam_tween.finished


func clear_map() -> void:
	for item in level.get_children():
		if item is Marker3D:
			item.remove_from_group("SPAWN_POINTS")
		item.queue_free()


func generate_map() -> void:
	generate_ground()
	generate_spawn_points()
	generate_walls()


func generate_ground() -> void:
	var ground: CSGBox3D = CSGBox3D.new()
	ground.size = Vector3(ground_length, 1.0, ground_breadth)
	var ground_material := StandardMaterial3D.new()
	ground_material.albedo_texture = preload("res://assets/ground-grid.png")
	ground_material.uv1_offset = Vector3(0,0,0.5)
	ground_material.uv1_triplanar = true
	ground.material = ground_material
	ground.use_collision = true
	level.add_child(ground)


func generate_walls() -> void:
	var wall_count: int = int((ground_length * ground_breadth) / 25)
	for i in range(wall_count):
		var wpos := Vector3(0.0, 0.5, 0.0)
		var wsize := Vector3(1.0, 4.0, 1.0)
		var walign: WALL_ALIGNMENT = WALL_ALIGNMENT.values().pick_random()
		if walign == WALL_ALIGNMENT.BOTH:
			if i % 2 == 0:
				walign = WALL_ALIGNMENT.HORIZONTAL
			else:
				walign = WALL_ALIGNMENT.VERTICAL
		wpos.x = int(randf_range(-(ground_length/2.25), (ground_length/2.25)))
		wpos.z = int(randf_range(-(ground_breadth/2.25), (ground_breadth/2.25)))
		if wall_position_set.has(wpos):
			if wall_position_set[wpos] == WALL_ALIGNMENT.VERTICAL:
				generate_wall(wpos, wsize, WALL_ALIGNMENT.HORIZONTAL)
				wall_position_set[wpos] = WALL_ALIGNMENT.BOTH
			elif wall_position_set[wpos] == WALL_ALIGNMENT.HORIZONTAL:
				generate_wall(wpos, wsize, WALL_ALIGNMENT.VERTICAL)
				wall_position_set[wpos] = WALL_ALIGNMENT.BOTH
			else:
				continue	## add a new wpos provider
		else:
			generate_wall(wpos, wsize, walign)
			wall_position_set[wpos] = walign
	#wpos = Vector3(5.0, 0.5, -3.0)
	#wsize = Vector3(0.5, 4.0, 7.0)
	#generate_wall(wpos, wsize)


func generate_wall(wall_pos: Vector3, wall_size: Vector3, wall_algin: WALL_ALIGNMENT) -> void:
	for _pos in spawn_points:
		if abs(_pos.x - wall_pos.x) < 2.0:
			if abs(_pos.z - wall_pos.z) < 2.0:
				print("SKIPPED FOR SPAWN_POINTS")
				return
	var wall: CSGBox3D = CSGBox3D.new()
	wall.position = wall_pos
	wall.size = wall_size
	var wall_material := StandardMaterial3D.new()
	wall_material.albedo_texture = preload("res://assets/bricks-cc0.jpg")
	wall_material.uv1_offset = Vector3(0,0,0.5)
	wall_material.uv1_triplanar = true
	wall_material.albedo_color = Color(0.82, 0.82, 0.82, 1.0)
	wall_material.roughness = 0.74
	wall_material.roughness_texture = NoiseTexture2D.new()
	wall.material = wall_material
	wall.use_collision = true
	if wall_algin == WALL_ALIGNMENT.VERTICAL:
		wall.rotation_degrees.y = 90
	level.add_child(wall)
	

func generate_spawn_points() -> void:
	player.position = Vector3(0.0, 1.0, 0.0)
	spawn_points = [player.position]
	for idx in range(3):
		var spawn_marker = Marker3D.new()
		spawn_marker.add_to_group("SPAWN_POINTS")
		var x = int(randf_range(-(ground_length/2.5), (ground_length/2.5))) - idx
		var z = int(randf_range(-(ground_breadth/2.5), (ground_breadth/2.5))) - idx
		spawn_marker.position = Vector3(x, 2.5, z)
		spawn_points.append(spawn_marker.position)
		level.add_child(spawn_marker)


func get_enemy_count() -> int:
	var counter_experience: int = (counter*counter)-(3*counter)
	var _count : float = counter * 2.75
	if counter < 4:
		_count = counter * 0.65
		return ceil(_count)
	if counter_experience < 0:
		_count = counter * 0.5
		return ceil(_count)
	elif counter_experience < counter:
		_count = counter * 0.9
		return ceil(_count)
	elif counter_experience < (5*counter):
		_count = counter * 0.85
		return ceil(_count)
	elif counter_experience < (10*counter):
		_count = counter * 0.75
		return ceil(_count)
	elif counter_experience < (20*counter):
		_count = counter * 0.8
		return ceil(_count)
	return ceil(_count)


func set_nfo() -> void:
	counter += 1
	nfo_label.text = str(counter) +\
	 " with length(" + str(ground_length) + ")" +\
	 " x breadth(" + str(ground_breadth) + ")" +\
	" | ENEMY: " + str(get_enemy_count())
