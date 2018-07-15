## for sprite of mouse with cheese

extends KinematicBody2D

# class variables
var motion = Vector2()

func _physics_process(delta):
	motion.y += 5

	# mouse movement
	if Input.is_action_pressed("ui_right"):
		motion.x = 100
	elif Input.is_action_pressed("ui_left"):
		motion.x = -100

	if Input.is_action_pressed("ui_up"):
		motion.y = -100
	elif Input.is_action_pressed("ui_down"):
		motion.y = 100

	if Input.is_action_just_released("ui_right"):
		motion.x = 0
	elif Input.is_action_just_released("ui_left"):
		motion.x = 0

	if Input.is_action_just_released("ui_up"):
		motion.y = 0
	elif Input.is_action_just_released("ui_down"):
		motion.y = 0

	move_and_slide(motion)

func _ready():
	pass