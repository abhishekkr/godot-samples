extends Node3D

var camroot_h: float = 0.0
var camroot_v: float = 0.0
@export var cam_v_max: int = 75
@export var cam_v_min: int = -55

var sensitivity_h: float = 0.01
var sensitivity_v: float = 0.01

var acceleration_h: float = 10.0
var acceleration_v: float = 10.0

func _ready() -> void:
	pass #Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * sensitivity_h
		camroot_v += event.relative.y * sensitivity_v


func _physics_process(delta: float) -> void:
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	get_node("H").rotation.y = lerpf(get_node("H").rotation.y, camroot_h, delta * acceleration_h)
	get_node("H/VSpringArm3D").rotation.x = lerpf(get_node("H/VSpringArm3D").rotation.x, camroot_v, delta * acceleration_v)
