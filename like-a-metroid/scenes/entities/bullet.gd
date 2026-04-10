extends Area2D


const SPEED: float = 200.0
var target: Vector2


func setup(t: Transform2D, dir: Vector2) -> void:
	transform = t
	target = (dir - position).normalized()
	look_at(dir)


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1.45, 1.45), 0.75).from(Vector2.ONE)

	
func _physics_process(delta: float) -> void:
	position += target * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if is_queued_for_deletion():
		return
	if "got_hit" in body:
		body.got_hit()
	queue_free()
