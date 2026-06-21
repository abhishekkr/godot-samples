extends Node

@onready var player: Player = get_tree().get_first_node_in_group("PLAYER")
@onready var spawn_markers = get_tree().get_nodes_in_group("SPAWN_POINTS")
var waves = [
	{'enemy_count': 2, 'second_between_spawn': 0.0},
	{'enemy_count': 3, 'second_between_spawn': 0.75},
	{'enemy_count': 5, 'second_between_spawn': 0.5},
	{'enemy_count': 7, 'second_between_spawn': 0.75},
	{'enemy_count': 9, 'second_between_spawn': 1.0},
]
var current_wave_id: int
var current_enemy_count: int
var can_spawn: bool = true

const enemy_scene: String = "res://entities/enemy.tscn"
const enemy_creation_gap: float = 0.25


func _ready() -> void:
	current_wave_id = -1
	current_enemy_count = 0
	set_can_spawn()


func start_next_wave() -> bool:
	if not can_spawn:
		return false
	current_wave_id += 1
	if current_wave_id >= waves.size():
		return false
		
	var current_wave: Dictionary = waves[current_wave_id]
	print(current_wave)
	if not current_wave.has("enemy_count") or current_wave['enemy_count'] <= 0:
		return false
	
	var prev_marker_index = -1
	for id in range(current_wave['enemy_count']):
		var enemy = load(enemy_scene).instantiate()
		var marker_index: int = randi_range(0, spawn_markers.size()-1)
		if marker_index == prev_marker_index:
			marker_index = 0 if marker_index == spawn_markers.size() - 1 else marker_index + 1
		var spawn_marker: Marker3D = spawn_markers[marker_index]
		#enemy.global_position = spawn_marker.global_position 	## since added as child to Marker
		enemy.attack_target = player
		enemy.death.connect(on_enemy_death)
		current_enemy_count += 1
		spawn_marker.add_child(enemy)
		print("Spawning enemy#", id, " at ", spawn_marker)
		await get_tree().create_timer(enemy_creation_gap).timeout
		prev_marker_index = marker_index
	return true


func get_current_wave_id() -> int:
	return current_wave_id


func wave_count() -> int:
	return waves.size()


func set_can_spawn() -> void:
	if spawn_markers.size() < 1:
		print("This level has no SPAWN_POINTS.")
		can_spawn = false
	else:
		for item in spawn_markers:
			if !(item is Marker3D):
				can_spawn = false
				print("This level has non MARKER3D SPAWN_POINTS, making it a faulty set.")
				break
		print("This level has spawn point count of ", spawn_markers.size())


func  on_enemy_death() -> void:
	current_enemy_count -= 1
	if current_enemy_count < 1:
		print("WAVE ENDED, START NEW WAVE.")
		start_next_wave()
