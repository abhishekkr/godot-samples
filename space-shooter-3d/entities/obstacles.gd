extends Area3D


@onready var obstacle_options = [$meteorHalf, $craterLarge, $RockCrystals, $SatelliteDishLarge]
@onready var obstacle_collision_options = [$meteorHalfCollision,
 $craterLargeCollision,
 $RockCrystalsCollision,
 $SatelliteDishLargeCollision]
var obstacle_index: int = -1
var obstacle: MeshInstance3D
var speed: float = 1.25
var direction_x: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction_x = randf_range(-0.2, 0.2)
	obstacle_index = randi_range(0, obstacle_options.size()-1)
	obstacle = obstacle_options[obstacle_index]
	for idx in range(obstacle_options.size()):
		if idx != obstacle_index:
			obstacle_options[idx].hide()
			obstacle_collision_options[idx].hide()
			obstacle_collision_options[idx].disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.z += speed * delta
	position.x += direction_x * delta * speed


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("got_hit"):
		body.got_hit()
