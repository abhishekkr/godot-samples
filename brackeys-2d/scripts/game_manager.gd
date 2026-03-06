extends Node

var score = 0

@onready var score_msg = get_tree().get_root().get_node("Game").find_child("ScoreLabel")
@onready var died_msg = get_tree().get_root().get_node("Game").find_child("DiedMsg")

func _ready() -> void:
	if score_msg:
		score_msg.show()
	

func add_coin() -> void:
	score += 1
	if score_msg:
		score_msg.text = "Coins %d" % score
	print("Score: ", score)


func show_dead_msg():
	if died_msg:
		died_msg.find_child("HurtSound").play()
		died_msg.show()
