extends CharacterBody3D

@onready var head = $head
@onready var cam = $head/Camera3D

enum PlayerState {CanMove, Interacting}

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sens = 0.2
@export var ray_length = 5.0

var player_state = PlayerState.CanMove

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * mouse_sens))
		head.rotate_x(-deg_to_rad(event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-50), deg_to_rad(0))
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta: float) -> void:
	handle_zoom(delta)

func _physics_process(delta: float) -> void:
	_handle_player_movement(delta)
	_handle_raycasts(delta)

func _handle_player_movement(delta: float) -> void:
	if player_state != PlayerState.CanMove:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func handle_zoom(delta: float):
	var base_zoom = 60.0
	var zoom = 40.0
	var zoom_speed = 4.0

	if Input.is_action_pressed("zoom"):
		cam.fov = lerp(cam.fov, zoom, delta * zoom_speed)
	else:
		cam.fov = lerp(cam.fov, base_zoom, delta * zoom_speed)

func _handle_raycasts(delta: float):
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result != {}:
		if result.collider is Object:
			var object = result.collider
			if object.has_method("interact"):
				print("Interactable")
			else:
				print("Cant interact")
