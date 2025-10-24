extends Control

@onready var window_mode_picker = $MarginContainer/ColorRect/VBoxContainer/video_container/window_cont/window_mode_picker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_populate_window_mode_picker()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _populate_window_mode_picker():
	window_mode_picker.add_item("Windowed", DisplayServer.WINDOW_MODE_WINDOWED)
	window_mode_picker.add_item("Fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	window_mode_picker.add_item("Exclusive Fullscreen", DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	window_mode_picker.add_item("Maximized", DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	window_mode_picker.select(1)

func _on_window_mode_picker_item_selected(index: int) -> void:
	var mode = window_mode_picker.get_item_id(index)
	DisplayServer.window_set_mode(mode)

func _on_close_button_up() -> void:
	hide()
