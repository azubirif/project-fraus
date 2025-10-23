extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("test_intro_text")
	
	await animation_finished	
	var pre = load("res://test.tscn")
	get_tree().change_scene_to_packed(pre)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
