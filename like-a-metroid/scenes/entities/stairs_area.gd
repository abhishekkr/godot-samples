extends Area2D

@export var ENTRY_TO_FLOOR: Node2D
@export var ENABLED: bool
@export var FINAL_GATE: bool


func _on_body_entered(body: Node2D) -> void:
	if !ENABLED:
		return
	if FINAL_GATE:
		print("You Won!")
		return
	body.position = ENTRY_TO_FLOOR.position
	$Timer.start()


func _on_timer_timeout() -> void:
	ENABLED = !ENABLED
	ENTRY_TO_FLOOR.ENABLED = !ENTRY_TO_FLOOR.ENABLED
