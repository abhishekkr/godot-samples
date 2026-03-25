extends CharacterBody2D

@export var SPEED: float = 100.0

@onready var player = get_node_or_null("/root/Level01/YSortEnabled/Player")
@onready var slime = $Slime
@onready var death_timer = $Timer     

var direction: Vector2
var is_enemy_hurt: bool = false
var is_enemy_dead: bool = false
var hearts: int = 3


func _ready() -> void:
	slime.play_walk()


func _physics_process(_delta: float) -> void:
	if player == null or is_enemy_dead or is_enemy_hurt:
		return
	direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()


func got_hit() -> void:
	is_enemy_hurt = true
	if hearts < 1:
		is_enemy_dead = true
	else:
		hearts -= 1
	slime.play_hurt()
	death_timer.start()


func _on_timer_timeout() -> void:
	if is_enemy_dead:
		queue_free()
	else:
		is_enemy_hurt = false
		slime.play_walk()
