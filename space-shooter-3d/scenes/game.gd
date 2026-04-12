extends Node3D


@onready var laser_scene : PackedScene = preload("res://entities/laser.tscn")
@onready var meteor_scene : PackedScene = preload("res://entities/meteor.tscn")
@onready var obstacle_scene : PackedScene = preload("res://entities/obstacles.tscn")
const FLOOR_SPEED: float = 1.5
const FLOOR_Z_FOR_RESET: float = 85.0 # (100-15) i.e. side length minus origin z
var score: int = 0


func _ready() -> void:
	%MeteorTimer.start()
	%GameOverMenu.hide()


func _process(delta: float) -> void:
	var floor_offset_z: float = FLOOR_SPEED * delta
	if $Floors/FloorMesh1.position.z > FLOOR_Z_FOR_RESET:
		$Floors/FloorMesh1.position.z = -115
	else:
		$Floors/FloorMesh1.position.z += floor_offset_z
	if $Floors/FloorMesh2.position.z > 35:
		$Floors/FloorMesh2.position.z = -115
	else:
		$Floors/FloorMesh2.position.z += floor_offset_z


func _on_player_shoot(pos: Vector3) -> void:
	var laser = laser_scene.instantiate() as Area3D
	laser.position = pos
	%Lasers.add_child(laser)


func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate() as Area3D
	meteor.position.x = randf_range(-45, 45)
	var rand_scale = randf_range(0.75, 2.5)
	meteor.scale = Vector3(rand_scale, rand_scale, rand_scale)
	meteor.connect("meteor_destroyed", _on_meteor_destroyed)
	%Meteors.add_child(meteor)


func _on_player_game_over() -> void:
	print("GAME OVER")
	%GameOverMenu.show()


func _on_player_player_hurt(lives_left: int) -> void:
	var heart_txt = " "
	for i in range(lives_left):
		heart_txt += "❤️"
	%Hearts.text = heart_txt


func _on_meteor_destroyed():
	score += 1
	%Score.text = str(score) + " "
	print(score)


func _on_obstacle_timer_timeout() -> void:
	var obstacle = obstacle_scene.instantiate() as Area3D
	obstacle.position.x = randf_range(-45, 45)
	obstacle.rotate_y(randf_range(120, 249))
	var rand_scale = randf_range(1.5, 2.5)
	obstacle.scale = Vector3(rand_scale, rand_scale, rand_scale)
	%Obstacles.add_child(obstacle)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	score = 0
	for node in get_tree().get_nodes_in_group("Lasers"):
		node.queue_free()
	for node in get_tree().get_nodes_in_group("Meteors"):
		node.queue_free()
	$Player.reset()
	%GameOverMenu.hide()
