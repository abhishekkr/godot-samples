extends Control

var score = 0

func _on_mob_squashed():
	score += 1
	$ScoreLabel.text = "Score: %s" % score
