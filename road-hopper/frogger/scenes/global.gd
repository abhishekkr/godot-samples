extends Node

@export var new_score: String = "New Score: __" : set = set_new_score, get = get_new_score


func set_new_score(score: String) -> void:
	new_score = score


func get_new_score() -> String:
	return new_score
