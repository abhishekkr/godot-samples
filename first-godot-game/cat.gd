## for sprite of cat

extends KinematicBody2D

# class variables
var motion = Vector2()

func _physics_process(delta):
	motion.y += 5

	# cat movement
	if Input.is_action_pressed("ui_up"):
		motion.x = 100
	elif Input.is_action_pressed("ui_down"):
		motion.x = -100

	if Input.is_action_just_released("ui_up"):
		motion.x = 0
	elif Input.is_action_just_released("ui_down"):
		motion.x = 0

	move_and_slide(motion)