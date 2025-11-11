extends Area2D


var direction: Vector2 = Vector2.LEFT
var speed: int = 100


func _ready() -> void:
	var CarSprite: Sprite2D = $Sprites.get_children().pick_random()
	CarSprite.visible = true
	if position.x < 0:
		direction = Vector2.RIGHT
		CarSprite.flip_h = !CarSprite.flip_h


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
