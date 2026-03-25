extends Area2D

@onready var direction = Vector2.RIGHT.rotated(rotation)

const SPEED: float = 1000
const MAX_DISTANCE: float = 600

var travelled_distance: float = 0.0

func _physics_process(delta: float) -> void:
	var new_distance = SPEED * delta
	position += direction * new_distance
	travelled_distance += new_distance
	if travelled_distance > MAX_DISTANCE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("got_hit"):
		body.got_hit()
	queue_free()
