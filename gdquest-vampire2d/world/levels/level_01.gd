extends Node2D


@onready var enemy_tscn = preload("res://world/characters/enemy.tscn")
@onready var enemy_path = %PathFollow2D
@onready var enemy_timer = %PathTimer
@onready var mob_node_tree = %Mobs
@onready var game_over_tscn = %GameOver


func _ready() -> void:
	spawn_mob()
	spawn_mob()
	spawn_mob()
	enemy_timer.start()
	game_over_tscn.hide()


func spawn_mob() -> void:
	var new_enemy = enemy_tscn.instantiate()
	enemy_path.progress_ratio = randf()
	new_enemy.global_position = enemy_path.global_position
	new_enemy.scale = Vector2(0.5, 0.5)
	new_enemy.SPEED = randf_range(25, 125)
	mob_node_tree.add_child(new_enemy)


func _on_path_timer_timeout() -> void:
	spawn_mob()


func _on_player_health_depleted() -> void:
	game_over_tscn.show()
	enemy_timer.stop()
	for mob in mob_node_tree.get_children():
		mob.queue_free()


func _on_button_pressed() -> void:
	spawn_mob()
	enemy_timer.start()
	game_over_tscn.hide()
