extends Node


@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/Fin.hide()
	$HUD/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	if get_node_or_null("Player") == null:
		$MobTimer.stop()
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	mob.squashed.connect($HUD._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$MobTimer.stop()
	$HUD/Fin.show()
	$HUD/Retry.show()

	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $HUD/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()


func _on_retry_pressed() -> void:
	if $HUD/Retry.visible:
		get_tree().reload_current_scene()
