extends Area3D

var speed: float = 3.0
var direction_x: float = 0.0
var rotate_base_x: float = 0.0
var rotate_base_z: float = 0.0
var hearts: int = 2
var active_material : Material
var blast_material: ShaderMaterial
@onready var meteor_shader_code = load("res://entities/meteor.gdshader")

func _ready() -> void:
	speed = randf_range(2, 5)
	direction_x = randf_range(-0.9, 0.9)
	rotate_base_x = randf_range(-0.9, 1.5)
	rotate_base_z = randf_range(-1.2, 1.25)
	active_material = %meteor.get_active_material(0)
	if active_material:
		blast_material = ShaderMaterial.new()
		blast_material.set_shader_parameter('code', meteor_shader_code)


func _physics_process(delta: float) -> void:	
	if hearts <= 0:
		return
	position.z += speed * delta
	position.x += direction_x * delta * speed
	rotate_x(rotate_base_x * delta)
	rotate_z(rotate_base_z * delta)


func _on_area_entered(area: Area3D) -> void:
	%meteor.set_surface_override_material(0, blast_material)
	%GotHitTimer.start()
	if area.has_method("destroy"):
		area.destroy()
	hearts -= 1
	if hearts > 0:
		return
	await get_tree().create_timer(0.9).timeout
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("got_hit"):
		body.got_hit()


func _on_got_hit_timer_timeout() -> void:
	%meteor.set_surface_override_material(0, active_material)
