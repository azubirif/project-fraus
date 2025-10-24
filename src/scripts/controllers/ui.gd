extends Control

@onready var settings = $TestSettings
var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()

func pause():
	if !is_paused:
		show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	is_paused = !is_paused


func _on_resume_button_up() -> void:
	pause()
	print("unpausing")


func _on_quit_button_up() -> void:
	get_tree().quit()


func _on_settings_button_up() -> void:
	settings.show()
