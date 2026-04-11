extends Node3D


@onready var laser_scene : PackedScene = preload("res://entities/laser.tscn")
@onready var meteor_scene : PackedScene = preload("res://entities/meteor.tscn")


func _ready() -> void:
	%MeteorTimer.start()


func _on_player_shoot(pos: Vector3) -> void:
	var laser = laser_scene.instantiate() as Area3D
	laser.position = pos
	%Lasers.add_child(laser)


func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate() as Area3D
	meteor.position.x = randf_range(-45, 45)
	var rand_scale = randf_range(0.75, 2.5)
	meteor.scale = Vector3(rand_scale, rand_scale, rand_scale)
	%Meteors.add_child(meteor)
