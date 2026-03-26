extends CharacterBody2D

signal health_depleted

@onready var player_body = %HappyBoo
@onready var health_bar = %HealthBar
@onready var feature_timer = %Timer

const SPEED = 300.0
const DAMAGE_PER_ENEMY_CONTACT_PER_SECOND = 5.0

var health: float = 100.0


func _ready() -> void:
	player_body.play_idle_animation()
	health_bar.hide()


func _physics_process(delta: float) -> void:
	var touching_mobs = %HurtBox.get_overlapping_bodies()
	if touching_mobs.size() > 0:
		health_bar.show()
		health -= (DAMAGE_PER_ENEMY_CONTACT_PER_SECOND * touching_mobs.size() * delta)
		health_bar.value = health
		if health <= 0.0:
			print("GAME OVER")
			health_depleted.emit()
	elif health_bar.visible == true:
		feature_timer.start()
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.length() > 0.0:
		player_body.play_walk_animation()
		move_and_slide()
	else:
		player_body.play_idle_animation() 


func _on_timer_timeout() -> void:
	print("TIMER TIME")
	if health_bar.visible == true:
		health_bar.hide()
