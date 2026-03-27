extends Area2D


const SPEED: float = 200.0
var target: Vector2


func setup(t: Transform2D, dir: Vector2) -> void:
	transform = t
	target = (dir - position).normalized()
	look_at(dir)
	
	
func _physics_process(delta: float) -> void:
	position += target * SPEED * delta
