extends Control


func _ready() -> void:
	$Score.text = Global.get_new_score()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		call_deferred("restart_game")


func _on_restart_pressed() -> void:
	call_deferred("restart_game")
	

func restart_game() -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file("res://frogger/scenes/game.tscn")
	else:
		print("[ERROR] Failed to load GAME.")


func _on_exit_pressed() -> void:
	get_tree().quit()
