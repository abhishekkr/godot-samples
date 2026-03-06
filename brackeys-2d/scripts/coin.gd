extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	GameManager.add_coin()
	$".".hide()
	$AudioStreamPlayer2D.play()
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
