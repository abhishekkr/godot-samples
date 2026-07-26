extends Node2D

@onready var start_page: Control = $CanvasLayer/StartPage
@onready var vn_page: Control = $CanvasLayer/VNPage
@onready var escape_page: Control = $CanvasLayer/EscapePage

@onready var confetti_fx: CPUParticles2D = $CanvasLayer/VNPage/CPUParticles2D
@onready var btn_restart: Button = $CanvasLayer/VNPage/BtnRestart


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(do_dialogic_signal)
	escape_page.hide()
	vn_page.hide()
	start_page.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		escape_page.show()


func do_dialogic_signal(token) -> void:
	match token:
		"finale":
			do_finale()


func do_finale() -> void:
	var confetti_gradient: Gradient = Gradient.new()
	if Dialogic.VAR.get_variable("Brie", 0.0) > 0.0:
		confetti_gradient.colors = PackedColorArray([
			Color.from_string("#eacb2c", Color.YELLOW),
			Color.from_string("#ff15ff", Color.HOT_PINK)
		])
	else:
		confetti_gradient.colors = PackedColorArray([
			Color.from_string("#111111", Color.BLACK),
			Color.from_string("#eeeeee", Color.GRAY)
		])
	confetti_fx.color_ramp = confetti_gradient
	vn_page.show()
	confetti_fx.show()
	var timer := get_tree().create_timer(1.0)
	timer.timeout.connect(btn_restart.show)


func _on_btn_restart_pressed() -> void:
	start_timeline_1()


func start_timeline_1() -> void:
	vn_page.hide()
	btn_restart.hide()
	confetti_fx.hide()
	Dialogic.start('timeline_i')


func _on_btn_start_pressed() -> void:
	start_page.hide()
	start_timeline_1()


func _on_mute_toggle_toggled(toggled_on: bool) -> void:
	Dialogic.VAR.set_variable('Audio', !toggled_on)


func _on_btn_resume_pressed() -> void:
	escape_page.hide()


func _on_btn_end_game_pressed() -> void:
	Dialogic.end_timeline(true)
	escape_page.hide()
	start_page.show()
