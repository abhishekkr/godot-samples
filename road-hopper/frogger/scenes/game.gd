extends Node2D

var car_scene: PackedScene = preload("res://frogger/scenes/car.tscn")
var score: int = 20


func _ready() -> void:
	$CanvasLayer/ScoreLabel.text = str(score)


func _on_car_timer_timeout() -> void:
	var count: int = [1, 3, 5].pick_random()
	for n in count:
		var car = car_scene.instantiate() as Area2D
		var car_spawn_marker = $CarSpawnMarkers.get_children().pick_random() as Marker2D
		car.position = car_spawn_marker.position
		$Objects.add_child(car)
		car.connect("body_entered", _on_car_accident);


func _on_finish_spot_body_entered(body: Node2D) -> void:
	print("Player in Finish Spot")
	var result: String = "Bravo!\nNew Score: " + str(score) + "s"
	call_deferred("change_scene",  result)


func _on_car_accident(body: Node2D) -> void:
	print("Accident:", body.name)
	var result: String = "Accident!!\nFailed in " + str(score) + "s"
	call_deferred("change_scene", result)
	

func change_scene(new_score: String) -> void:
	Global.set_new_score(new_score)
	if is_inside_tree():
		get_tree().change_scene_to_file("res://frogger/scenes/title.tscn")
	else:
		print("[ERROR] Failed to load TITLE.")


func _on_score_timer_timeout() -> void:
	score -= 1
	if score <= 0:
		call_deferred("change_scene", "Timed Out!")
	$CanvasLayer/ScoreLabel.text = str(score)
